//
//  StudentLocationClient.swift
//  OnTheMap
//
//  Created by felix on 8/11/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import Foundation

class StudentLocationClient {
    
    private static var studentLocationClient = StudentLocationClient()
    
    static func sharedStudentLocationClient() -> StudentLocationClient{
        return studentLocationClient
    }
    
    
    func fetchStudentLoactionList(completionHandler: (info: String?, success: Bool) -> Void) {
        
        var headers = [String:String]()
        headers["X-Parse-Application-Id"] = Constants.Parse.ApplicationID
        headers["X-Parse-REST-API-Key"] = Constants.Parse.APIKey
        
        var parameters = [String:AnyObject!] ()
        parameters["limit"] = 100
        parameters["order"] = "-updatedAt"
        
        HTTPHelper.HTTPRequest(Constants.ApiSecureScheme,
                                    host: Constants.Parse.ApiHost,
                                    path: Constants.Parse.ApiPath,
                                    pathExtension: Constants.Parse.ApiPathExtension,
                                    headers: headers,
                                    parameters: parameters ) { (data, statusCode, error) in
                                        
                                        guard self.completionHandlerForStudentLocation(data, error: error, completionHandler: completionHandler) else {
                                            return
                                        }
                                        
                                        completionHandler(info: "Fetch student location succcessfully, count: \(OnTheMapModel.sharedModel().count())",  success: true)
                                    }
    }
    
    func postStudentLocation(studentLocation: StudentLocation, completionHandler: (info: String?, success: Bool) -> Void) {
        
        var headers = [String:String]()
        headers["X-Parse-Application-Id"] = Constants.Parse.ApplicationID
        headers["X-Parse-REST-API-Key"] = Constants.Parse.APIKey
        headers["Content-Type"] = "application/json"
        
        let HTTPBody = "{\"uniqueKey\": \"\(studentLocation.uniqueKey)\", \"firstName\": \"\(studentLocation.firstName)\", \"lastName\": \"\(studentLocation.lastName)\",\"mapString\": \"\(studentLocation.mapString)\", \"mediaURL\": \"\(studentLocation.mediaURL)\",\"latitude\": \(studentLocation.latitude), \"longitude\": \(studentLocation.longitude)}"
        
        HTTPHelper.HTTPRequest(Constants.ApiSecureScheme,
                               host: Constants.Parse.ApiHost,
                               path: Constants.Parse.ApiPath,
                               pathExtension: Constants.Parse.ApiPathExtension,
                               HTTPMethod: Constants.HTTPMethod.POST,
                               headers: headers,
                               HTTPBody: HTTPBody ) { (data, statusCode, error) in
                                
                                guard self.completionHandlerForPostStudentLocation(data, error: error, completionHandler: completionHandler) else {
                                    return
                                }
                                completionHandler(info: "Post student location succcessfully.",  success: true)
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
        
        return true
    }
    
    private func completionHandlerForPostStudentLocation(data: NSData?, error: NSError?, completionHandler: (info: String?, success: Bool) -> Void) -> Bool {
        
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
        
        
        guard let objectId = parsedResult["objectId"] as? String else {
            completionHandler(info: "Could not find objectId in the response: \(parsedResult)",  success: false)
            return false
        }

        print("Student location objectId is: \(objectId)")
        
        return true
    }
    
    private func parseStudentLocations(data: AnyObject!) -> Bool{
        if let results = data["results"] as? [AnyObject] {
            
            OnTheMapModel.sharedModel().clearStudateLocationList()
            
            for result in results {
                if let result = result as? [String:AnyObject] {
                    if let studentLocation = StudentLocation(dictionary: result) {
                        OnTheMapModel.sharedModel().append(studentLocation)
                    }
                }
            }
            if OnTheMapModel.sharedModel().count() > 0 {
                return true
            }
        }
        return false
    }
}