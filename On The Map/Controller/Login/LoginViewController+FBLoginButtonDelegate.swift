//
//  LoginViewController+FBLoginButtonDelegate.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print(" Facebook Login Complete")
        if let accessToken = AccessToken.current {
            udacityLoginView.loginWithAccessToken(accessToken: accessToken.authenticationToken)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Facebook Logout complete")
    }
}
