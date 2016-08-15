//
//  OnTheMapModel.swift
//  OnTheMap
//
//  Created by felix on 8/12/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import Foundation

class OnTheMapModel {
    
    static private var shardModel = OnTheMapModel()
    static func sharedModel() -> OnTheMapModel  {
        return shardModel
    }
    var udacityClient = UdacityClient()
    var studentLocationClient = StudentLocationClient()
    
}