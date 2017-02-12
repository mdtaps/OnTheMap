//
//  UdacityConvenienceFunctions.swift
//  OnTheMap
//
//  Created by Worship Computer on 2/6/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    func authenticateWithCredentials(_ userEmail: String, _ password: String, _ completionHandlerForAuthentication: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        UdacityClient.shared.userEmail = userEmail
        UdacityClient.shared.password = password
        
        getAccountKey() { (success, accountKey, error) in
        
            if success {
                UdacityClient.shared.userId = accountKey
                completionHandlerForAuthentication(true, nil)
            } else {
                completionHandlerForAuthentication(false, error!.localizedDescription)
            }
            
        }
    }
    
    func populatePersonalData(_ completionHandlerForPersonalData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getUserData() { (success, error) in

                if success {
                    completionHandlerForPersonalData(success, nil)
                } else {
                    completionHandlerForPersonalData(success, error?.localizedDescription)
                }
        }
    }
    
    private func getAccountKey(completionHandlerForAccountKey: @escaping (_ success: Bool, _ accountKey: String?, _ error: NSError?) -> Void) {
        
        udacityPOSTTaskWith(method: UdacityClient.Methods.session) { (results, error) in
            if error != nil {
                completionHandlerForAccountKey(false, nil, error)
            } else {
                guard let account = results?["account"] as? [String: AnyObject] else {
                    completionHandlerForAccountKey(false, nil, NSError(domain: "getSessionId", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to get account info from parsed Json data"]))
                    return
                }
                
                if let key = account["key"] as? String {
                    print(key)
                    completionHandlerForAccountKey(true, key, nil)
                } else {
                    completionHandlerForAccountKey(false, nil, NSError(domain: "getSessionId", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to get account key from parsed Json data"]))
                }
            }
        }
        
    }
    
    private func getUserData(_ completionHandlerForUserData: @escaping (_ success: Bool, _ error: NSError?) -> Void ) {
    
        guard let userId = userId else {
            completionHandlerForUserData(false, NSError(domain: "getUserData", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to make request, userId not established"]))
            return
        }
        
        udacityGETTaskWith(urlMethod: (UdacityClient.Methods.UserId + "/\(userId)")) { (results, error) in
            
            func sendError(_ errorString: String) {
                completionHandlerForUserData(false, NSError(domain: "getUserData", code: 1, userInfo: [NSLocalizedDescriptionKey: errorString]))
            }
            
            if error != nil {
                completionHandlerForUserData(false, error)
            } else {
                guard let user = results?["user"] as? AnyObject else {
                    sendError("Unable to find \"user\" in: \(results)")
                    return
                }
                
                guard let firstName = user["first_name"] as? String else {
                    sendError("Unable to find \"first_name\" in \(results)")
                    return
                }
                
                self.userFirstName = firstName
                
                guard let lastName = user["last_name"] as? String else {
                    sendError("Unable to find \"last_name\" in \(results)")
                    return
                }
                
                self.userLastName = lastName
                
                print(lastName + ", " + firstName)
                
                completionHandlerForUserData(true, nil)
            }
            
        }
    }
}

