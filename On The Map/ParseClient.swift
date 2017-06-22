//
//  ParseClient.swift
//  On The Map
//
//  Created by Javon Davis on 21/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

class ParseClient: Client {
    
    static let shared = ParseClient()
    
    var requestToken: String?
    var sessionID: String?
    
    let studentLocationURL = Constants.Parse.url + Constants.Parse.Paths.studentLocation
    
    func getDefaultHeaders() -> [String: String] { // Default Headers containing the header information for the application ID and API Key
        return [
            Constants.Headers.Keys.parseApplicationID: Constants.Headers.Values.parseApplicationID,
            Constants.Headers.Keys.parseApiKey: Constants.Headers.Values.parseApiKey
        ]
    }
    
    // MARK:- Parse API Methods
    
    func getStudentLocations() {
        super.get(url: studentLocationURL, with: getDefaultHeaders()) { data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
    }
    
    func getStudentLocation(with uniqueKey: String) {
        let uniqueKeyDict = [
            Constants.Parse.URLParameters.uniqueKey:uniqueKey
        ]
        
        let jsonData = try! JSONSerialize(jsonObject: uniqueKeyDict as [String : AnyObject])
        let parameters = [
            "where": NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        ]
        
        super.get(url: studentLocationURL, with: getDefaultHeaders(), parameters: parameters as [String : AnyObject]) { data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
    }
    
    func postStudentLocation(studentLocation: StudentLocation, updating: Bool = false) {
        // Add the Content type to the Headers
        var headers = getDefaultHeaders()
        headers[Constants.Headers.Keys.contentType] = Constants.Headers.Values.applicationJSON
        
        // Build the body of the request
        let studentLocationDict = studentLocation.toDictionary()
        let jsonData = try! JSONSerialize(jsonObject: studentLocationDict)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        
        var url = studentLocationURL
        let completion: SessionResponse = { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        
        if updating {
            url += "/\(studentLocation.objectId!)"
            super.put(urlString: url, headers: headers, body: jsonString! as String, completion: completion)
        } else {
            super.post(urlString: url, headers: headers, body: jsonString! as String, completion: completion)
        }
    }
}
