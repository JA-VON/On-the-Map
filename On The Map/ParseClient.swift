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
    
    let studentLocationURL = Constants.Parse.url + Constants.Parse.Paths.studentLocation
    
    func getDefaultHeaders() -> [String: String] { // Default Headers containing the header information for the application ID and API Key
        return [
            Constants.Headers.Keys.parseApplicationID: Constants.Headers.Values.parseApplicationID,
            Constants.Headers.Keys.parseApiKey: Constants.Headers.Values.parseApiKey
        ]
    }
    
    // MARK:- Parse API Methods
    
    func getStudentLocations(completion: @escaping ParseStudentLocationsResponse) {
        super.get(url: studentLocationURL, with: getDefaultHeaders()) { data, err in
            if let err = err {
                print("\(err.localizedDescription)")
                completion(nil, err)
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            do {
                let jsonArray = try self.JSONDeserializeArray(jsonData: data!)
                var studentLocations = [StudentLocation]()
                
                for jsonDict in jsonArray {
                    studentLocations.append(StudentLocation.from(jsonDict: jsonDict))
                }
                completion(studentLocations, nil)
            } catch {
                print(error.localizedDescription)
                let userInfo = [NSLocalizedDescriptionKey : error.localizedDescription]
                completion(nil, NSError(domain: "StudentCreationFromJSON", code: 1, userInfo: userInfo))
            }
        }
    }
    
    func getStudentLocation(with uniqueKey: String, completion: @escaping ParseStudentLocationResponse) {
        // Build the Body Parameters
        let uniqueKeyDict = [
            Constants.Parse.URLParameters.uniqueKey:uniqueKey
        ]
        
        let jsonData = try! JSONSerialize(jsonObject: uniqueKeyDict as [String : AnyObject])
        let parameters = [
            "where": NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        ]
        
        super.get(url: studentLocationURL, with: getDefaultHeaders(), parameters: parameters as [String : AnyObject]) { data, err in
            if let err = err {
                print("\(err.localizedDescription)")
                completion(nil, err)
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            do {
                let jsonDict = try self.JSONDeserializeObject(jsonData: data!)
                completion(StudentLocation.from(jsonDict: jsonDict), nil)
            } catch {
                print(error.localizedDescription)
                let userInfo = [NSLocalizedDescriptionKey : error.localizedDescription]
                completion(nil, NSError(domain: "StudentCreationFromJSON", code: 1, userInfo: userInfo))
            }
        }
    }
    
    func postStudentLocation(studentLocation: StudentLocation, updating: Bool = false, completion: @escaping ParsePostStudentLocationResponse) {
        // Add the Content type to the Headers
        var headers = getDefaultHeaders()
        headers[Constants.Headers.Keys.contentType] = Constants.Headers.Values.applicationJSON
        
        // Build the body of the request
        let studentLocationDict = studentLocation.toDictionary()
        let jsonData = try! JSONSerialize(jsonObject: studentLocationDict)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        
        var url = studentLocationURL
        let requestCompletion: SessionResponse = { data, error in // First class citizen to the rescue!
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            completion(nil)
        }
        
        if updating {
            url += "/\(studentLocation.objectId!)" // Append the objectID to the URL
            super.put(urlString: url, headers: headers, body: jsonString! as String, completion: requestCompletion)
        } else {
            super.post(urlString: url, headers: headers, body: jsonString! as String, completion: requestCompletion)
        }
    }
}
