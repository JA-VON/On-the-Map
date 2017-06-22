//
//  Client.swift
//  On The Map
//
//  Created by Javon Davis on 21/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

class Client {
    
    func get(url urlString: String, with headers: [String: String] = [:], and body: String = "", parameters: [String:AnyObject] = [:], completion: @escaping SessionResponse) {
        performRequestOn(url: urlString, using: "GET", with: headers, and: body, parameters: parameters, completion: completion)
    }
    
    func post(url urlString: String, with headers: [String: String] = [:], and body: String = "", parameters: [String:AnyObject] = [:], completion: @escaping SessionResponse) {
        performRequestOn(url: urlString, using: "POST", with: headers, and: body,parameters: parameters, completion: completion)
    }
    func put(url urlString: String, with headers: [String: String] = [:], and body: String = "", parameters: [String:AnyObject] = [:], completion: @escaping SessionResponse) {
        performRequestOn(url: urlString, using: "PUT", with: headers, and: body, parameters: parameters, completion: completion)
    }
    
    private func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
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
    
    private func performRequestOn(url urlString: String, using method: String, with headers: [String: String], and body: String, parameters: [String:AnyObject], completion: @escaping SessionResponse) {
        
        // Build the URL
        let urlParametersString = escapedParameters(parameters)
        let finalURLString = urlString + urlParametersString
        
        let request = NSMutableURLRequest(url: URL(string: finalURLString)!)
        
        // Set the method of the Request
        request.httpMethod = method
        
        // Set the Headers, if any
        for (httpHeaderField, value) in headers {
            request.addValue(value, forHTTPHeaderField: httpHeaderField)
        }
        
        // Set the body of the HTTP Request if it's not a GET request
        if method != "GET" {
            request.httpBody = body.data(using: String.Encoding.utf8)
        }
        
        // Start the session Task
        let task = URLSession.shared.dataTask(with: (request as URLRequest) as URLRequest, completionHandler: completion)
        task.resume()
    }
}
