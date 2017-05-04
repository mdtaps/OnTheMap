//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Lindsey Renee Eaton on 2/17/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaUrl: String
    let objectId: String
    let uniqueKey: String
    
    init?(studentDictionary: [String: AnyObject]) {
        
        guard let latitude = studentDictionary["latitude"] as? Double,
            let longitude = studentDictionary["longitude"] as? Double,
            let objectId = studentDictionary["objectId"] as? String else
        {
                return nil
        }
        
        self.latitude = latitude
        self.longitude = longitude
        self.objectId = objectId
        
        uniqueKey = studentDictionary["uniqueKey"] as? String ?? ""
        firstName = studentDictionary["firstName"] as? String ?? ""
        lastName = studentDictionary["lastName"] as? String ?? ""
        mapString = studentDictionary["mapString"] as? String ?? ""
        mediaUrl = studentDictionary["mediaURL"] as? String ?? ""
    }
}

extension StudentInformation {
    
    static func studentsArrayFromStudentData(_ dataArray: [[String: AnyObject]]) -> [StudentInformation] {
        
        var array = [StudentInformation]()
        
        for studentData in dataArray {
            if let student = StudentInformation(studentDictionary: studentData) {
                array.append(student)
            }
        }
        
        return array
    }
}
