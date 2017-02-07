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
        
        getSessionId() { (success, sessionId, error) in
        
            if success {
                completionHandlerForAuthentication(true, nil)
            } else {
                
            }
            
        }
    }
    
    private func getSessionId( completionHandlerForSessionId: @escaping (_ success: Bool, _ sessionId: String?, _ error: NSError?) -> Void) {
        
        
    }
}

