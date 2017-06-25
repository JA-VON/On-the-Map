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

    var studentLocations = [StudentLocation]()
    var annotations = [MKPointAnnotation]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getAnnotation(studentLocation: StudentLocation) -> MKPointAnnotation {
        // Notice that the float values are being used to create CLLocationDegree values.
        // This is a version of the Double type.
        let lat = CLLocationDegrees(studentLocation.latitude)
        let long = CLLocationDegrees(studentLocation.longitude)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let first = studentLocation.firstName!
        let last = studentLocation.lastName!
        let mediaURL = studentLocation.mediaURL!
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        return annotation
    }
    
    func updateMap() {
        loadingIndicator.stopAnimating()
        self.mapView.removeAnnotations(annotations)
        annotations = [MKPointAnnotation]()
        for studentLocation in StudentLocation.studentLocations {
            annotations.append(getAnnotation(studentLocation: studentLocation))
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    func focus(location: StudentLocation) {
        let latitude = CLLocationDegrees(location.latitude)
        let longitude = CLLocationDegrees(location.longitude)
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func saveToParse(location: StudentLocation, annotation: MKPointAnnotation) {
        ParseClient.shared.postStudentLocation(studentLocation: location, updating: locationExistsForCurrentUser(), completion: { error in
            if let error = error {
                print(error.localizedDescription)
                self.showAlert(title: "Oops!", message: "There was an error saving your location to the database")
                self.refresh()
                return
            }
            self.appDelegate.userLocation = location
        })
    }
    
    func confirm(studentLocation: StudentLocation, annotation: MKPointAnnotation) {
        var message = "Do you want to save this location"
        var location = studentLocation // StudentLocation is a struct
        
        if locationExistsForCurrentUser() {
            message = "Do you want to Overwrite your existing location at \(appDelegate.userLocation!.mapString!)?"
            
            location.objectId = appDelegate.userLocation?.objectId!
        }
        
        let alertController = UIAlertController(title: "Confirm Location", message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.saveToParse(location: location, annotation: annotation)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
            self.mapView.removeAnnotation(annotation)
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func confirmNewLocation(location: StudentLocation) {
        let annotation = getAnnotation(studentLocation: location)
        self.mapView.addAnnotation(annotation)
        focus(location: location)
        confirm(studentLocation: location, annotation: annotation)
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
        if let newLocation = appDelegate.newLocation { // Add a new location for a Student
            confirmNewLocation(location: newLocation)
            appDelegate.newLocation = nil
            refresh()
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
                self.showAlert(title: "Oops!", message: error.localizedDescription)
                return
            }
            self.updateMap()
        })
        
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "showStudentInformation", sender: self)
    }

}
