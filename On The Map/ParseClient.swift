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
    
    func getStudentLocations() {
        
        let url = Constants.Parse.url + Constants.Parse.Paths.studentLocation
        
        let headers = [
            Constants.Parse.Headers.Keys.applicationID: Constants.Parse.Headers.Values.applicationID,
            Constants.Parse.Headers.Keys.apiKey: Constants.Parse.Headers.Values.apiKey
        ]
        
        super.get(url: url, with: headers) { data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
    }
}
