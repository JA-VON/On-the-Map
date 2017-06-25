//
//  StudentMapViewController.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit
import MapKit
import FacebookLogin

class StudentMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var annotations = [MKPointAnnotation]()
    var switchingTabs = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func updateMap() {
        loadingIndicator.stopAnimating()
        mapView.removeAnnotations(annotations)
        annotations = [MKPointAnnotation]()
        for studentLocation in StudentLocation.studentLocations {
            annotations.append(getAnnotation(studentLocation: studentLocation))
        }
        
        // When the array is complete, we add the annotations to the map.
        mapView.addAnnotations(annotations)
    }
    
    func focus(location: StudentLocation) {
        let latitude = CLLocationDegrees(location.latitude)
        let longitude = CLLocationDegrees(location.longitude)
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the view
        mapView.delegate = self
        loadingIndicator.stopAnimating()
        refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !switchingTabs {
            refresh()
            switchingTabs = false
        }
    }
    
    // MARK:- IBActions
    
    @IBAction func logoutClicked(_ sender: Any) {
        loadingIndicator.startAnimating()
        UdacityClient.shared.endSession(completion: { sessionId, userId, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(sessionId!)
            }
            performUIUpdatesOnMain {
                 self.loadingIndicator.stopAnimating()
                 self.tabBarController?.navigationController?.popViewController(animated: true)
            }
        })
        LoginManager().logOut()
    }

    @IBAction func refresh() {
        loadingIndicator.startAnimating()
        loadStudentLocations(completion: { error in
            if let error = error {
                self.loadingIndicator.stopAnimating()
                self.showAlert(title: "Oops!", message: error.localizedDescription)
                return
            }
            self.updateMap()
            if let location = self.appDelegate.userLocation {
                self.focus(location: location)
            }
        })
        
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        if locationExistsForCurrentUser() {
            let message = "Do you want to overwrite your existing location at \(appDelegate.userLocation!.mapString!)?"
            
            let alertController = UIAlertController(title: "Careful", message: message, preferredStyle: .actionSheet)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "showStudentInformation", sender: self)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "showStudentInformation", sender: self)
        }
    }

}
