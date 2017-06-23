//
//  LoginViewController.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var udacityLoginView: UdacityLoginView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension LoginViewController: UdacityDelegate {
    
    func didAttemptLogin(with email: String, password: String) {
        print("Email: \(email), Password: \(password)")
    }
    
    func didCompleteLogin(sessionId: String?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        print("Session: \(sessionId!)")
    }
    
    func didClickSignUp() {
        print("Sign up clicked")
    }
}
