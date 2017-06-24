//
//  UdacityClient.swift
//  On The Map
//
//  Created by Javon Davis on 22/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

class UdacityClient: Client {
    
    static let shared = UdacityClient()
    
    let sessionURL = Constants.Udacity.url + Constants.Udacity.Paths.session
    let usersURL = Constants.Udacity.url + Constants.Udacity.Paths.users
    
    func handleSession(data: Data?, completion: UdacitySessionResponse){
        do {
            let jsonDict = try self.JSONDeserialize(jsonData: data!)
            var userId: String?
            if let account = jsonDict["account"] as? Dictionary<String, AnyObject>
            {
                userId = getSafeString(value: account["key"])
            }
            
            let session = jsonDict["session"] as! Dictionary<String, AnyObject>
            let sessionId = getSafeString(value: session["id"])
            completion(sessionId, userId, nil)
        } catch {
            print(error.localizedDescription)
            let userInfo = [NSLocalizedDescriptionKey : error.localizedDescription]
            completion(nil, nil, NSError(domain: "StudentCreationFromJSON", code: 1, userInfo: userInfo))
        }
    }
    
    func startSession(username: String? = nil, password: String? = nil, accessToken: String? = nil, completion: @escaping UdacitySessionResponse) {
        
        guard (username != nil && password != nil) || accessToken != nil else {
            let errorDescription = "Need either username(email) and password or a Facebook Access Token"
            print(errorDescription)
            let userInfo = [NSLocalizedDescriptionKey : errorDescription]
            completion(nil, nil, NSError(domain: "StartSession", code: 1, userInfo: userInfo))
            return
        }
        
        // Build the HTTP Headers
        let headers = [
            Constants.Headers.Keys.accept: Constants.Headers.Values.applicationJSON,
            Constants.Headers.Keys.contentType: Constants.Headers.Values.applicationJSON
        ]
        
        var parameters: [String: AnyObject]
        
        // Decide whether this is a Facebook login or not
        
        if let accessToken = accessToken {
            // Build the URL parameters
            let fbCredentialsDict = [
                Constants.Facebook.URLParameters.accessToken: accessToken
            ]
            
            let jsonData = try! JSONSerialize(jsonObject: fbCredentialsDict as [String : AnyObject])
            parameters = [
                Constants.Facebook.URLParameters.facebookMobile: NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
            ]
        } else {
            // Build the URL parameters
            let udacityCredentialsDict = [
                Constants.Udacity.URLParameters.username: username!,
                Constants.Udacity.URLParameters.password: password!
            ]
            
            let jsonData = try! JSONSerialize(jsonObject: udacityCredentialsDict as [String : AnyObject])
            parameters = [
                Constants.Udacity.URLParameters.udacity: NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
            ]
        }
        
        super.post(urlString: sessionURL, headers: headers, parameters: parameters as [String : AnyObject]) { data, err in
            if let err = err { // Handle error…
                print("\(err.localizedDescription)")
                completion(nil, nil, err)
                return
            }
            
            // Remove the uneccessary but neccessary firt 5 characters used for security purposes
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            
            self.handleSession(data: newData, completion: completion)
        }
    }
    
    func endSession(completion: @escaping UdacitySessionResponse) {
        // Custom Udacity client code for ending session
        let request = NSMutableURLRequest(url: URL(string: sessionURL)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error { // Handle error…
                print("\(error.localizedDescription)")
                completion(nil, nil, error)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            self.handleSession(data: newData, completion: completion)
        }
        task.resume()
    }
    
    func getUser(with userId: String, completion: @escaping UdacityUserResponse) {
        let url = usersURL + "/\(userId)" // Append the user's ID to the URL
        super.get(url: url, completion: { data, err in
            if let err = err { // Handle error…
                print("\(err.localizedDescription)")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            
            do {
                let jsonDict = try self.JSONDeserialize(jsonData: newData!)
                let udacityUser = UdacityUser.from(jsonDict: jsonDict)
                completion(udacityUser, nil)
            } catch {
                print(error.localizedDescription)
                let userInfo = [NSLocalizedDescriptionKey : error.localizedDescription]
                completion(nil, NSError(domain: "StudentCreationFromJSON", code: 1, userInfo: userInfo))
            }
            
        })
    }
}
