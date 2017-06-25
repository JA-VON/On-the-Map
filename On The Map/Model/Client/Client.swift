//
//  Client.swift
//  On The Map
//
//  Created by Javon Davis on 21/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

class Client {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
    
    // MARK: - Convenience Functions
    
    func get(url urlString: String, with headers: [String: String] = [:], body: String = "", parameters: [String:AnyObject] = [:], completion: @escaping SessionResponse) {
        performRequestOn(url: urlString, using: .get, with: headers, and: body, parameters: parameters, completion: completion)
    }
    
    func post(urlString: String, headers: [String: String] = [:], body: String = "", parameters: [String:AnyObject] = [:], completion: @escaping SessionResponse) {
        performRequestOn(url: urlString, using: .post, with: headers, and: body,parameters: parameters, completion: completion)
    }
    func put(urlString: String, headers: [String: String] = [:], body: String = "", parameters: [String:AnyObject] = [:], completion: @escaping SessionResponse) {
        performRequestOn(url: urlString, using: .put, with: headers, and: body, parameters: parameters, completion: completion)
    }
    
    // MARK:- JSON Serialization and Deserialization
    
    func JSONSerialize(jsonObject: [String: AnyObject]) throws -> Data {
        return try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
    }
    
    func JSONDeserialize(jsonData: Data) throws -> Dictionary<String, AnyObject> { // For Deserializing a JSONObject
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! Dictionary<String, AnyObject>
    }
    
    // MARK:- Netowrk Request Functionss
    
    private func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                print(value)
                // make sure that it is a string value
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
                
            }
            
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
    func performRequestOn(url urlString: String, using method: HTTPMethod, with headers: [String: String], and body: String, parameters: [String:AnyObject], completion: @escaping SessionResponse) {
        
        // Build the URL
        let urlParametersString = escapedParameters(parameters)
        let finalURLString = urlString + urlParametersString
        
        let request = NSMutableURLRequest(url: URL(string: finalURLString)!)
        
        // Set the method of the Request
        request.httpMethod = method.rawValue
        
        // Set the Headers, if any
        for (httpHeaderField, value) in headers {
            request.addValue(value, forHTTPHeaderField: httpHeaderField)
        }
        
        // Set the body of the HTTP Request if it's not a GET request
        if method != .get {
            request.httpBody = body.data(using: String.Encoding.utf8)
        }
        
        // Start the session Task
        let task = URLSession.shared.dataTask(with: (request as URLRequest) as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForNetworkRequest", code: 1, userInfo: userInfo))
            }

            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error!.localizedDescription)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                /* GUARD: Did we get a successful 2XX response? */
                guard statusCode >= 200 && statusCode <= 299 else {
                    var message = "Please try again later"
                    
                    if statusCode >= 400 && statusCode <= 499 {
                        message = "Please check your credentials"
                    } else if statusCode >= 500 && statusCode <= 599 {
                        message = "There was an error with Udacity servers, Please try again later"
                    }
                    sendError(message)
                    return
                }
            }
            

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("Please try again later")
                return
            }
            
            completion(data, nil)
        }
        task.resume()
    }
}
