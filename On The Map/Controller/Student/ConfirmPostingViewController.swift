//
//  ConfirmPostingViewController.swift
//  On The Map
//
//  Created by Javon Davis on 25/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit
import MapKit

class ConfirmPostingViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var studentLocation: StudentLocation?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadingIndicator.stopAnimating()
        if let studentLocation = studentLocation {
            confirmNewLocation(location: studentLocation)
        }
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
    
    func saveToParse(location: StudentLocation) {
        ParseClient.shared.postStudentLocation(studentLocation: location, updating: locationExistsForCurrentUser(), completion: { error in
            self.loadingIndicator.stopAnimating()
            if let error = error {
                print(error.localizedDescription)
                self.showAlert(title: "Oops!", message: "There was an error saving your location to the database")
                return
            }
            
            self.appDelegate.userLocation = location
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func confirmNewLocation(location: StudentLocation) {
        let annotation = getAnnotation(studentLocation: location)
        mapView.addAnnotation(annotation)
        focus(location: location)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        loadingIndicator.startAnimating()
        self.saveToParse(location: studentLocation!)
    }
}

extension ConfirmPostingViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                let url = URL(string: toOpen)!
                if app.canOpenURL(url) {
                    app.open(url)
                } else {
                    showAlert(title: "Oh No!", message: "Could not open URL")
                }
            }
        }
    }
}
