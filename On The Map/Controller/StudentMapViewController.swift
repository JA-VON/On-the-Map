//
//  StudentMapViewController.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit
import MapKit

class StudentMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!

    var studentLocations = [StudentLocation]()
    var annotations = [MKPointAnnotation]()
    
    let parseClient = ParseClient.shared
    
    func updateMap() {
        self.mapView.removeAnnotations(annotations)
        annotations = [MKPointAnnotation]()
        for studentLocation in studentLocations {
            
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
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    func loadStudentLocations() {
        parseClient.getStudentLocations(completion: { studentLocations, error in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.studentLocations = studentLocations!
            performUIUpdatesOnMain {
                self.updateMap()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudentLocations()
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        UdacityClient.shared.endSession(completion: { sessionId, error in
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

    
}
