//
//  StudentMapViewController.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit
import MapKit

protocol AddLocationDelegate {
    func setNewLocation(location: StudentLocation)
}

class StudentMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    var studentLocations = [StudentLocation]()
    var annotations = [MKPointAnnotation]()
    var newLocation: StudentLocation?
    
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
        self.mapView.removeAnnotations(annotations)
        annotations = [MKPointAnnotation]()
        for studentLocation in self.appDelegate.studentLocations {
            annotations.append(getAnnotation(studentLocation: studentLocation))
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    func refresh() {
        loadStudentLocations(completion: updateMap)
        
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
    
    func confirm(annotation: MKPointAnnotation) {
        let alertController = UIAlertController(title: "Confirm Location", message: "Save this location", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { alert in
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
        confirm(annotation: annotation)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let newLocation = newLocation { // Add a new location for a Student
            confirmNewLocation(location: newLocation)
        }
        refresh()
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        UdacityClient.shared.endSession(completion: { sessionId, userId, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(sessionId!)
            }
            performUIUpdatesOnMain {
                 self.performSegue(withIdentifier: "showLogin", sender: self)
            }
        })
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "showStudentInformation", sender: self)
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        refresh()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStudentInformation" {
            let destinationVc = segue.destination as! StudentInformationViewController
            destinationVc.delegate = self
        }
    }
}

extension StudentMapViewController: AddLocationDelegate {
    
    func setNewLocation(location: StudentLocation) {
        self.newLocation = location
    }
    
}
