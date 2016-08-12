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
    
    func fetchStudentLoactionList(completionHandler: (info: String?, success: Bool) -> Void) {
        
        var headers = [String:String]()
        headers["X-Parse-Application-Id"] = Constants.Parse.ApplicationID
        headers["X-Parse-REST-API-Key"] = Constants.Parse.APIKey
        
        var parameters = [String:AnyObject!] ()
        parameters["limit"] = 100
        parameters["order"] = "-updatedAt"
        
        HelperFunctions.HTTPRequest(Constants.ApiSecureScheme,
                                    host: Constants.Parse.ApiHost,
                                    path: Constants.Parse.ApiPath,
                                    pathExtension: Constants.Parse.ApiPathExtension,
                                    headers: headers,
                                    parameters: parameters ) { (data, statusCode, error) in
                                        
                                        guard self.completionHandlerForStudentLocation(data, error: error, completionHandler: completionHandler) else {
                                            return
                                        }
                                        
                                        completionHandler(info: "Fetch student location succcessfully, count: \(self.studentLocationList.count)",  success: true)
                                    }
    }
    
    private func completionHandlerForStudentLocation(data: NSData?, error: NSError?, completionHandler: (info: String?, success: Bool) -> Void) -> Bool {
        
        guard (error == nil) else {
            completionHandler(info: "There was an error with your request.",  success: false)
            return false
        }
        
        guard let data = data else {
            completionHandler(info: "No data was returned by the request!",  success: false)
            return false
        }
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            completionHandler(info: "Could not parse the data as JSON: \(data)",  success: false)
        }
        
        guard parseStudentLocations(parsedResult) else {
            completionHandler(info: "Could not find student location in the response data.",  success: false)
            return false
        }
        print("Student location in the list: \(self.studentLocationList.count)")
        
        return true
    }
    
    private func parseStudentLocations(data: AnyObject!) -> Bool{
        if let results = data["results"] as? [AnyObject] {
            print("Student location from server count: \(results.count)")
            
            clearStudateLocationList()
            
            for result in results {
                if let result = result as? [String:AnyObject] {
                    if let studentLocation = StudentLocation(dictionary: result) {
                        studentLocationList.append(studentLocation)
                    }
                }
            }
            if !studentLocationList.isEmpty {
                return true
            }
        }
        return false
    }
}