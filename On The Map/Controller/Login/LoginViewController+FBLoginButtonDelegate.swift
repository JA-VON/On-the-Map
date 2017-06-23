//
//  LoginViewController+FBLoginButtonDelegate.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import FacebookLogin

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print(" Facebook Login Complete")
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Facebook Logout complete")
    }
}
