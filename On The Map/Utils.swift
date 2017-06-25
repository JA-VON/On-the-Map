//
//  Utils.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation
import UIKit

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
