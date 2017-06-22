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
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
        }
    }
    
    func endSession() {
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
}
