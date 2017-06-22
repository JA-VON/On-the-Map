//
//  Constants.swift
//  On The Map
//
//  Created by Javon Davis on 21/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Udacity {
        static let url = "https://www.udacity.com/api/"
    }
    
    struct Parse {
        static let url = "https://parse.udacity.com/parse/classes"
        
        struct Headers {
            
            struct Keys {
                static let applicationID = "X-Parse-Application-Id"
                static let apiKey = "X-Parse-REST-API-Key"
            }
            
            struct Values {
                static let applicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
                static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            }
        }
        
        struct Paths {
            static let studentLocation = "/StudentLocation"
        }
        
    }
}
