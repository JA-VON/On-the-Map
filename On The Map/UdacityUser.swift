//
//  UdacityUser.swift
//  On The Map
//
//  Created by Javon Davis on 22/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

struct UdacityUser {
    var key: String!
    var firstName: String!
    var lastName: String!
    
    // For testing
    static var dummy: UdacityUser {
        var udacityUser = UdacityUser()
        udacityUser.key = "1234"
        udacityUser.firstName = "John"
        udacityUser.lastName = "Doe"
        return udacityUser
    }
    
    static func from(jsonDict: Dictionary<String, AnyObject>) -> UdacityUser {
        var udacityUser = UdacityUser()
        
        udacityUser.key = jsonDict["uniqueKey"] as! String
        udacityUser.firstName = jsonDict["firstName"] as! String
        udacityUser.lastName = jsonDict["lastName"] as! String
        return udacityUser
    }
}
