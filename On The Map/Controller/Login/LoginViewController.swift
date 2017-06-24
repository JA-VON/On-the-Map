//
//  LoginViewController.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController {
    @IBOutlet weak var udacityLoginView: UdacityLoginView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        udacityLoginView.delegate = self
        
        // Add Facebook Login Button
        let loginButton = LoginButton(readPermissions: [.publicProfile])
        loginButton.delegate = self
        udacityLoginView.addView(view: loginButton)
    }
}

extension LoginViewController: UdacityDelegate {
    func didAttemptLogin(with email: String, password: String) {
        print("Email: \(email), Password: \(password)")
    }
    
    func didCompleteLogin(sessionId: String?, userId: String?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            showAlert(title: "Oops!", message: "There was an error logging you in, please try again later")
            return
        }
        
        print("Session: \(sessionId!)")
        print("User: \(userId!)")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.userId = userId
        self.performSegue(withIdentifier: "showHome", sender: self)
    }
}
