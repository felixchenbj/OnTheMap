//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by felix on 8/11/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import Foundation

struct StudentLocation {
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    var createdAt: NSDate
    var updatedAt: NSDate
    
    init?(dictionary: [String:String]) {
        if let objectId = dictionary[StudentLocation.Keys.objectId],
           let uniqueKey = dictionary[StudentLocation.Keys.uniqueKey],
           let firstName = dictionary[StudentLocation.Keys.firstName],
           let lastName = dictionary[StudentLocation.Keys.lastName],
           let mapString = dictionary[StudentLocation.Keys.mapString],
           let mediaURL = dictionary[StudentLocation.Keys.mediaURL],
           let latitude = dictionary[StudentLocation.Keys.latitude],
           let longitude = dictionary[StudentLocation.Keys.longitude],
           let createdAt = dictionary[StudentLocation.Keys.createdAt],
           let updatedAt = dictionary[StudentLocation.Keys.updatedAt] {
            
            self.objectId = objectId
            self.uniqueKey = uniqueKey
            self.firstName = firstName
            self.lastName = lastName
            self.mapString = mapString
            self.mediaURL = mediaURL
            self.latitude = Double(latitude)!
            self.longitude = Double(longitude)!
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            self.createdAt = dateFormatter.dateFromString( createdAt )!
            self.updatedAt = dateFormatter.dateFromString( updatedAt )!
        } else {
            return nil
        }
    }
}