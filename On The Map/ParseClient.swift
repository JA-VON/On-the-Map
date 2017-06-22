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
            Constants.Parse.Headers.Keys.applicationID: Constants.Parse.Headers.Values.applicationID,
            Constants.Parse.Headers.Keys.apiKey: Constants.Parse.Headers.Values.apiKey
        ]
    }
    
    func getStudentLocation(uniqueKey: String) {
        let uniqueKeyDict = [
            Constants.Parse.URLParameters.uniqueKey:uniqueKey
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: uniqueKeyDict, options: .prettyPrinted)
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
    
    func getStudentLocations() {
        super.get(url: studentLocationURL, with: getDefaultHeaders()) { data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
    }
}
