//
//  Constants.swift
//  OnTheMap
//
//  Created by felix on 8/11/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import Foundation

struct Constants {
    // MARK: URLs
    static let ApiScheme = "http"
    static let ApiSecureScheme = "https"
    
    static let ApiHost = "api.themoviedb.org"
    
    static let ApiPath = "/3"
    static let AuthorizationURL: String = "https://www.themoviedb.org/authenticate/"
    
    static let UdacitySession = "https://www.udacity.com/api/session"
    
    struct HTTPMethod {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
    }
    
    struct Udacity {
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let ApiPathExtension = "/session"
    }
    
    struct Parse {
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse"
        static let ApiPathExtension = "/classes/StudentLocation"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
}

extension StudentLocation {
    struct Keys {
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
    }
}