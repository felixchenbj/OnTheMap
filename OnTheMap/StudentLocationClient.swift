//
//  StudentLocationClient.swift
//  OnTheMap
//
//  Created by felix on 8/11/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import Foundation

class StudentLocationClient {
    
    var studentLocationList = [StudentLocation]()
    
    func clearStudateLocationList() {
        studentLocationList.removeAll()
    }
    
    func fetchStudentLoactionList(completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        /*
        let request = NSMutableURLRequest(URL: NSURL(string: Constants.Parse.ParseForStudentLocation)!)
        
        request.addValue(Constants.Parse.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Parse.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(result: nil, error: NSError(domain: "fetchStudentLoactionList", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }

            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
        return task
         */
    }
}