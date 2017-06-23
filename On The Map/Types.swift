//
//  Types.swift
//  On The Map
//
//  Created by Javon Davis on 21/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

typealias SessionResponse = (Data?, Error?) -> Void // Response from the execution of a SessionTask without the URLResponse?, URL Response parsed in Client

// MARK:- Convenience types for UdacityClient
typealias UdacityUserResponse = (UdacityUser?, Error?) -> Void
typealias UdacitySessionResponse = (String?, String?, Error?) -> Void // First String is the Session ID, Second is the User ID

// MARK:- Convenience types for ParseClient
typealias ParseStudentLocationsResponse = ([StudentLocation]?, Error?) -> Void
typealias ParseStudentLocationResponse = (StudentLocation?, Error?) -> Void
typealias ParsePostStudentLocationResponse = (Error?) -> Void
