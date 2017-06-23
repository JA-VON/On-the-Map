//
//  LoginDelegate.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

@objc protocol UdacityDelegate: class { // Class means this protocol can't be implemented by a struct
    func loginAttempted(with email: String, password: String)
    func loginCompleted(sessionId: String?, error: Error?)
    @objc optional func signUp() // Needed to make objc to not force conform on this function
}
