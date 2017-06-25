//
//  StudentLocation.swift
//  On The Map
//
//  Created by Javon Davis on 22/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    static var studentLocations = [StudentLocation]() // Locations to be used throughout the project
    
    // MARK: - Properties
    
    var objectId: String!
    var uniqueKey: String!
    var firstName: String!
    var lastName: String!
    var mapString: String!
    var mediaURL: String!
    var latitude: Float!
    var longitude: Float!
    
    init() {
        // Default Initializer
    }
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        objectId = getSafeString(value: jsonDict["objectId"])
        uniqueKey = getSafeString(value: jsonDict["uniqueKey"])
        firstName = getSafeString(value: jsonDict["firstName"])
        lastName = getSafeString(value: jsonDict["lastName"])
        mapString = getSafeString(value: jsonDict["mapString"])
        mediaURL = getSafeString(value: jsonDict["mediaURL"])
        latitude = getSafeFloat(value: jsonDict["latitude"])
        longitude = getSafeFloat(value: jsonDict["longitude"])
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
