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
    
    private func getAccountKey( completionHandlerForAccountKey: @escaping (_ success: Bool, _ accountKey: String?, _ error: NSError?) -> Void) {
        
        udacityPostTask { (results, error) in
            if error != nil {
                completionHandlerForAccountKey(false, nil, error)
            } else {
                guard let account = results?["account"] as? [String: AnyObject] else {
                    completionHandlerForAccountKey(false, nil, NSError(domain: "getSessionId", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to get account info from parsed Json data"]))
                    return
                }
                
                if let key = account["key"] as? String {
                    completionHandlerForAccountKey(true, key, nil)
                } else {
                    completionHandlerForAccountKey(false, nil, NSError(domain: "getSessionId", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to get account key from parsed Json data"]))
                }
            }
        }
        
    }
}

