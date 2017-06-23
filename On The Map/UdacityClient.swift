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
    
    func startSession(username: String? = nil, password: String? = nil, accessToken: String? = nil) {
        // Build the HTTP Headers
        let headers = [
            Constants.Headers.Keys.accept: Constants.Headers.Values.applicationJSON,
            Constants.Headers.Keys.contentType: Constants.Headers.Values.applicationJSON
        ]
        
        var parameters: [String: AnyObject]
        
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
        
        super.post(urlString: sessionURL, headers: headers, parameters: parameters as [String : AnyObject]) { data, response, error in
            if let error = error { // Handle error…
                print("\(error.localizedDescription)")
                return
            }
            // TODO: Move into abstract client and only pass error or data to the handler
//            func sendError(_ error: String) {
//                print(error)
//                let userInfo = [NSLocalizedDescriptionKey : error]
//                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
//            }
//
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                sendError("There was an error with your request: \(error)")
//                return
//            }
//
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                sendError("Your request returned a status code other than 2xx!")
//                return
//            }
//
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                sendError("No data was returned by the request!")
//                return
//            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
    }
    
    func endSession() {
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
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
    func getUser(with userId: String) {
        let url = usersURL + "/\(userId)" // Append the user's ID to the URL
        super.get(url: url, completion: { (data, response, error) in
            if let error = error { // Handle error…
                print("\(error.localizedDescription)")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        })
    }
}
