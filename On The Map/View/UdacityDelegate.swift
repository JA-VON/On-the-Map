//
//  LoginDelegate.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation


protocol UdacityDelegate: class { // Class means this protocol can't be implemented by a struct
    func didAttemptLogin(with email: String, password: String)
    func didCompleteLogin(sessionId: String?, error: Error?)
    func didClickSignUp()
}
