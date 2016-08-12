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
    
    init?(dictionary: [String:AnyObject]) {
        
        if let objectId = dictionary[StudentLocation.Keys.objectId] as? String,
           let uniqueKey = dictionary[StudentLocation.Keys.uniqueKey] as? String,
           let firstName = dictionary[StudentLocation.Keys.firstName] as? String,
           let lastName = dictionary[StudentLocation.Keys.lastName] as? String,
           let mapString = dictionary[StudentLocation.Keys.mapString] as? String,
           let mediaURL = dictionary[StudentLocation.Keys.mediaURL] as? String,
           let latitude = dictionary[StudentLocation.Keys.latitude] as? Double,
           let longitude = dictionary[StudentLocation.Keys.longitude] as? Double,
           let createdAt = dictionary[StudentLocation.Keys.createdAt] as? String,
           let updatedAt = dictionary[StudentLocation.Keys.updatedAt]  as? String {
            
            self.objectId = objectId
            self.uniqueKey = uniqueKey
            self.firstName = firstName
            self.lastName = lastName
            self.mapString = mapString
            self.mediaURL = mediaURL
            self.latitude = latitude
            self.longitude = longitude
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let createdAtDate = dateFormatter.dateFromString( createdAt ) {
                self.createdAt = createdAtDate
            } else {
                self.createdAt = NSDate()
            }
            if let updatedAtDate = dateFormatter.dateFromString( updatedAt ) {
                self.updatedAt = updatedAtDate
            } else {
                self.updatedAt = NSDate()
            }
        } else {
            return nil
        }
    }
}