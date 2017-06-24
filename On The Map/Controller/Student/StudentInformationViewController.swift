//
//  StudentInformationViewController.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit
import CoreLocation

class StudentInformationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.stopAnimating()
    }

    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        loadingIndicator.startAnimating()
        
        guard !(locationTextField.text?.isEmpty)! else {
            self.showAlert(title: "No Location", message: "Please enter a location")
            loadingIndicator.stopAnimating()
            return
        }
        
        let webURL = websiteTextField.text!
        
        let locationString = locationTextField.text!
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationString) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    self.showAlert(title: "No Location Found", message: "Could not find your location")
                    self.loadingIndicator.stopAnimating()
                    return
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if let userId = appDelegate.userId {
                UdacityClient.shared.getUser(with: userId, completion: { udacityUser, error in
                    guard error == nil else {
                        self.showAlert(title: "Oops!", message: "Could not get user information")
                        self.performSegue(withIdentifier: "showLogin", sender: self)
                        self.loadingIndicator.stopAnimating()
                        return
                    }
                    
                    var studentLocation = StudentLocation()
                    studentLocation.uniqueKey = appDelegate.userId!
                    studentLocation.firstName = udacityUser?.firstName
                    studentLocation.lastName = udacityUser?.lastName
                    studentLocation.mediaURL = webURL
                    studentLocation.latitude = Float(location.coordinate.latitude)
                    studentLocation.longitude = Float(location.coordinate.longitude)
                    studentLocation.mapString = locationString
                    
                    self.loadingIndicator.stopAnimating()
                    appDelegate.newLocation = studentLocation
                    self.dismiss(animated: true, completion: nil)
                })
            } else {
                self.showAlert(title: "Oops!", message: "No user id found, please log in")
                self.performSegue(withIdentifier: "showLogin", sender: self)
                self.loadingIndicator.stopAnimating()
                return
            }
            
        }
    }

}
