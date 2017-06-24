//
//  StudentLocation.swift
//  On The Map
//
//  Created by Javon Davis on 22/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    // MARK: - Properties
    
    var objectId: String!
    var uniqueKey: String!
    var firstName: String!
    var lastName: String!
    var mapString: String!
    var mediaURL: String!
    var latitude: Float!
    var longitude: Float!
    
    // For testing
    static var dummy: StudentLocation {
        var studentLocation = StudentLocation()
        studentLocation.objectId = "nnJLprqCtQ"
        studentLocation.uniqueKey = "1234"
        studentLocation.firstName = "John"
        studentLocation.lastName = "Doe"
        studentLocation.mapString = "Mountain View, CA"
        studentLocation.mediaURL = "https://udacity.com"
        studentLocation.latitude = 37.386052
        studentLocation.longitude = -122.083851
        return studentLocation
    }
    
    // MARK:- Serialization and deserialization
    
    static func from(jsonDict: Dictionary<String, AnyObject>) -> StudentLocation {
        var studentLocation = StudentLocation()
        
        studentLocation.objectId = getSafeString(value: jsonDict["objectId"])
        studentLocation.uniqueKey = getSafeString(value: jsonDict["uniqueKey"])
        studentLocation.firstName = getSafeString(value: jsonDict["firstName"])
        studentLocation.lastName = getSafeString(value: jsonDict["lastName"])
        studentLocation.mapString = getSafeString(value: jsonDict["mapString"])
        studentLocation.mediaURL = getSafeString(value: jsonDict["mediaURL"])
        studentLocation.latitude = getSafeFloat(value: jsonDict["latitude"])
        studentLocation.longitude = getSafeFloat(value: jsonDict["longitude"])
        return studentLocation
    }
    
    func toDictionary() -> Dictionary<String, AnyObject> {
        var jsonDict = [String: AnyObject]()
        jsonDict["uniqueKey"] = self.uniqueKey as AnyObject
        jsonDict["firstName"] = self.firstName as AnyObject
        jsonDict["lastName"] = self.lastName as AnyObject
        jsonDict["mapString"] = self.mapString as AnyObject
        jsonDict["mediaURL"] = self.mediaURL as AnyObject
        jsonDict["latitude"] = self.latitude as AnyObject
        jsonDict["longitude"] = self.longitude as AnyObject
        return jsonDict
    }
}

// Help with debugging by having human readable form of StudentLocation struct
extension StudentLocation: CustomStringConvertible {
    var description: String {
        return "\(self.objectId!)" + "\n"
            + "\(self.uniqueKey!)" + "\n"
            + "\(self.firstName!)" + "\n"
            + "\(self.lastName!)" + "\n"
            + "\(self.mapString!)" + "\n"
            + "\(self.mediaURL!)" + "\n"
            + "\(self.latitude!)" + "\n"
            + "\(self.longitude!)" + "\n"
    }
}
