//
//  LoginViewController.swift
//  On The Map
//
//  Created by Javon Davis on 21/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let parseClient = ParseClient.shared
        parseClient.getStudentLocations()
    }
}

