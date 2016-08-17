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
    
    var studentLocationList = [StudentLocation]()
    
    func clearStudateLocationList() {
        studentLocationList.removeAll()
    }
    
    func count() -> Int{
        return studentLocationList.count
    }
    
    func getStudentLocatAt(index: Int) -> StudentLocation? {
        guard index >= 0 && index < studentLocationList.count else {
            return nil
        }
        return studentLocationList[index]
    }
    
    func append(studentLocation: StudentLocation) {
        studentLocationList.append(studentLocation)
    }
    
    func getStudentLocationList() -> [StudentLocation]{
        return studentLocationList
    }
}