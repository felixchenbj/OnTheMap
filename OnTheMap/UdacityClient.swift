//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by felix on 8/11/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import Foundation

class UdacityClient {
    var sessionID = ""
    var accountKey = ""
    var firstName = ""
    var lastName = ""
    
    private static var udacityClient = UdacityClient()
    static func sharedUdacityClient() -> UdacityClient {
        return udacityClient
    }
    
    func login(userName: String, password: String, completionHandler: (info: String?, success: Bool) -> Void) {
        
        if userName.isEmpty || password.isEmpty {
            completionHandler(info: "Username or password should not be empty!",  success: false)
            return
        }
        
        var headers = [String:String]()
        headers["Accept"] = "application/json"
        headers["Content-Type"] = "application/json"
        
        let HTTPBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}"
        
        HTTPHelper.HTTPRequest(Constants.ApiSecureScheme,
                                    host: Constants.Udacity.ApiHost,
                                    path: Constants.Udacity.ApiPath,
                                    pathExtension: Constants.Udacity.ApiPathExtension,
                                    headers: headers,
                                    HTTPMethod: Constants.HTTPMethod.POST,
                                    HTTPBody: HTTPBody) { (data, statusCode, error) in
                        
                                        guard self.completionHandlerForUdacity(data, error: error, completionHandler: completionHandler) else {
                                            return
                                        }
                                        
                                        if !self.sessionID.isEmpty {
                                            completionHandler(info: "Login succcessfully, session id: \(self.sessionID)",  success: true)
                                        } else {
                                            completionHandler(info: "Login failed, could not get session id.",  success: false)
                                        }
                                    }
    }
    
    func logoff(completionHandler: (info: String?, success: Bool) -> Void) {
        
        var headers = [String:String]()
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            headers["X-XSRF-TOKEN"] = xsrfCookie.value
        }
        
        HTTPHelper.HTTPRequest(Constants.ApiSecureScheme,
                                    host: Constants.Udacity.ApiHost,
                                    path: Constants.Udacity.ApiPath,
                                    pathExtension: Constants.Udacity.ApiPathExtension,
                                    HTTPMethod: Constants.HTTPMethod.DELETE,
                                    headers: headers ) { (data, statusCode, error) in
                        
                                        guard self.completionHandlerForUdacity(data, error: error, completionHandler: completionHandler) else {
                                            return
                                        }
                        
                                        if !self.sessionID.isEmpty {
                                            completionHandler(info: "Login succcessfully, session id: \(self.sessionID)",  success: true)
                                        } else {
                                            completionHandler(info: "Login failed, could not get session id.",  success: false)
                                        }
                                    }
    }
    
    private func completionHandlerForUdacity(data: NSData?, error: NSError?, completionHandler: (info: String?, success: Bool) -> Void) -> Bool {
        
        guard (error == nil) else {
            completionHandler(info: "There was an error with your request.",  success: false)
            return false
        }
        
        guard let data = data else {
            completionHandler(info: "No data was returned by the request!",  success: false)
            return false
        }
        
        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            completionHandler(info: "Could not parse the data as JSON: \(data)",  success: false)
        }
        
        self.parseSessionID(parsedResult)
        self.parseAccountKey(parsedResult)
        self.parseUserInfo(parsedResult)

        return true
    }
    
    func getUserInfo(completionHandler: (info: String?, success: Bool) -> Void) {
        if !accountKey.isEmpty {
            HTTPHelper.HTTPRequest(Constants.ApiSecureScheme,
                                   host: Constants.Udacity.ApiHost,
                                   path: Constants.Udacity.ApiPath,
                                   pathExtension: Constants.Udacity.ApiUserData + "/\(accountKey)") { (data, statusCode, error) in
                                    
                                    guard self.completionHandlerForUdacity(data, error: error, completionHandler: completionHandler) else {
                                        return
                                    }
                                    
                                    if !self.lastName.isEmpty {
                                        if !self.firstName.isEmpty {
                                            completionHandler(info: "Get user info succcessfully: \(self.firstName) \(self.lastName)",  success: true)
                                            return
                                        }
                                    }
                                    
                                    completionHandler(info: "Get user info failed.",  success: false)
                                    
                                }
        }

    }
    
    private func parseSessionID(data: AnyObject!) -> Bool{
        if let session = data["session"] as? [String: AnyObject] {
            if let id = session["id"] as? String {
                sessionID = id
                return true
            }
        }
        return false
    }
    
    private func parseAccountKey(data: AnyObject!) -> Bool{
        if let account = data["account"] as? [String: AnyObject] {
            if let key = account["key"] as? String {
                accountKey = key
                return true
            }
        }
        return false
    }
    
    private func parseUserInfo(data: AnyObject!) -> Bool {
        if let user = data["user"] as? [String: AnyObject] {
            if let lastname = user["last_name"] as? String {
                self.lastName = lastname
                
                if let firstname = user["first_name"] as? String {
                    self.firstName = firstname
                    return true
                }
            }
        }
        return false
    }

}