//
//  Utils.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import UIKit
import MapKit

func loadStudentLocations(completion: @escaping (Error?)->()) {
    ParseClient.shared.getStudentLocations(completion: { studentLocations, error in
        
        guard error == nil else {
            completion(error)
            return
        }
        
        StudentLocation.studentLocations = studentLocations!
        performUIUpdatesOnMain {
            completion(nil)
        }
    })
}


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

func getSafeString(value: AnyObject?) -> String {
    return value as? String ?? ""
}

func getSafeFloat(value: AnyObject?) -> Float {
    return value as? Float ?? 0
}

let locationExistsForCurrentUser = { () -> Bool in 
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.userLocation != nil
}
