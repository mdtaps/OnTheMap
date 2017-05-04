//
//  ParseConveniceFunctions.swift
//  OnTheMap
//
//  Created by Worship Computer on 2/11/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation

extension ParseClient {
    
    func populateStudentPins( _ completionHandlerForPins: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getPinDataFromJsonObject { (success, error) in
            
            if error != nil {
                completionHandlerForPins(false, error?.localizedDescription ?? "An unknown error occured")
            } else {
                completionHandlerForPins(true, nil)
            }
        }
     }
    
    func getPinDataFromJsonObject(_ completionHandlerForPinData: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        func sendError(errorString: String) {
            completionHandlerForPinData(false, NSError(domain: "getPinDataFromJsonObject", code: 1, userInfo: [NSLocalizedDescriptionKey: errorString]))
        }
        
        parseGETTask() { (parsedData, error) in
            
            if error != nil {
                completionHandlerForPinData(false, error)
                return
            } else {
                
                guard let results = parsedData?["results"] as? [[String: AnyObject]] else {
                    sendError(errorString: "Failed to find \"results\" in: \(String(describing: parsedData))")
                    return
                }
                
                self.studentPins = StudentInformation.studentsArrayFromStudentData(results)
                
                completionHandlerForPinData(true, nil)
            }
        }
    }
    
    func submitUserPinData(pinData: [String: AnyObject], _ completionHandlerForUserPin: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        parsePOSTTask(jsonObject: pinData) { (success, error) in
            if !success {
                completionHandlerForUserPin(false, error?.localizedDescription)
                return
            }
            
            if error != nil {
                completionHandlerForUserPin(false, error?.localizedDescription)
            } else {
                completionHandlerForUserPin(true, nil)
            }
        }
        
    }
    
/*    func getDataForUserPin(_ completionHandlerForUserPinData: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        func sendError(errorString: String) {
            completionHandlerForUserPinData(false, NSError(domain: "getPinDataFromJsonObject", code: 1, userInfo: [NSLocalizedDescriptionKey: errorString]))
        }

        parsePOSTTask() { (parsedData, error) in
            
            if error != nil {
                completionHandlerForUserPinData(false, error)
                return
            } else {
                
                guard let results = parsedData?["results"] as? [[String: AnyObject]] else {
                    sendError(errorString: "Failed to find \"results\" in: \(String(describing: parsedData))")
                    return
                }
                
                self.studentPins = StudentInformation.studentsArrayFromStudentData(results)
                
                completionHandlerForUserPinData(true, nil)
            }
        }
    }
*/
}
