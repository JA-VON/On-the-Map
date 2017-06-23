//
//  Constants.swift
//  On The Map
//
//  Created by Javon Davis on 21/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Headers {
        
        struct Keys {
            static let parseApplicationID = "X-Parse-Application-Id"
            static let parseApiKey = "X-Parse-REST-API-Key"
            static let contentType = "Content-Type"
            static let accept = "Accept"
        }
        
        struct Values {
            static let parseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
            static let parseApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            static let applicationJSON = "application/json"
        }
    }
    
    
    struct Udacity {
        static let url = "https://www.udacity.com/api"
        
        struct Paths {
            static let session = "/session"
            static let users = "/users"
        }
        
        struct URLParameters {
            static let udacity = "udacity"
            static let username = "username"
            static let password = "password"
        }
    }
    
    struct Parse {
        static let url = "https://parse.udacity.com/parse/classes"
        
        struct Paths {
            static let studentLocation = "/StudentLocation"
        }
        
        struct URLParameters {
            static let uniqueKey = "uniqueKey"
        }
    }
    
    struct Facebook {
        static let appID = "365362206864879"
        static let URLSchemeSuffix = "onthemap"
        
        struct URLParameters {
            static let facebookMobile = "facebook_mobile"
            static let accessToken = "access_token"
        }
    }
    
    struct TableViewCellIdentifiers {
        static let studentList = "studentListTableViewCell"
    }
}
