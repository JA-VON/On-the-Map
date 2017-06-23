//
//  LoginViewController.swift
//  On The Map
//
//  Created by Javon Davis on 21/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let udacityClient = UdacityClient.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parseClient = ParseClient.shared
//        parseClient.getStudentLocations()
//        parseClient.getStudentLocation(with: "171219548")
//        parseClient.postStudentLocation(studentLocation: StudentLocation.dummy)
//        parseClient.postStudentLocation(studentLocation: StudentLocation.dummy, updating: true)
        
        
        
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        udacityClient.startSession(username: "javonldavis14@gmail.com", password: "Novajj14")
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        udacityClient.endSession()
    }
}

