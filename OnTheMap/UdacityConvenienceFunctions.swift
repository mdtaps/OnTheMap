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
    
    func logoutFromUdacity(completionHandlerForLogout: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        deleteLoginToken() { (success, error) in
            
            if success {
                completionHandlerForLogout(success, nil)
            } else {
                completionHandlerForLogout(success, error?.localizedDescription)
            }
        }
        
    }
    
    func loginWithFacebook(_ completionHandlerForFacebookLogin: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getFacebookLoginToken { (success, error) in
            
            if success {
                completionHandlerForFacebookLogin(success, nil)
            } else {
                completionHandlerForFacebookLogin(success, error?.localizedDescription)
            }
        }
    }
    
    private func getAccountKey(completionHandlerForAccountKey: @escaping (_ success: Bool, _ accountKey: String?, _ error: NSError?) -> Void) {
        
        udacityPOSTTaskWith(method: Methods.session) { (results, error) in
            if error != nil {
                completionHandlerForAccountKey(false, nil, error)
            } else {
                guard let account = results?["account"] as? [String: AnyObject] else {
                    completionHandlerForAccountKey(false, nil, NSError(domain: "getAccountKey", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to get account info from parsed Json data"]))
                    return
                }
                
                if let key = account["key"] as? String {
                    completionHandlerForAccountKey(true, key, nil)
                } else {
                    completionHandlerForAccountKey(false, nil, NSError(domain: "getAccountKey", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to get account key from parsed Json data"]))
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
                completionHandlerForUserData(false, NSError(domain: "udacityGETTaskWith", code: 1, userInfo: [NSLocalizedDescriptionKey: errorString]))
            }
            
            if error != nil {
                sendError(error?.localizedDescription ?? "An unknown error occured")
            } else {
                guard let user = results?["user"] as? AnyObject else {
                    sendError("Unable to find \"user\" in: \(String(describing: results))")
                    return
                }
                
                guard let firstName = user["first_name"] as? String else {
                    sendError("Unable to find \"first_name\" in \(String(describing: results))")
                    return
                }
                
                self.userFirstName = firstName
                
                guard let lastName = user["last_name"] as? String else {
                    sendError("Unable to find \"last_name\" in \(String(describing: results))")
                    return
                }
                
                self.userLastName = lastName
                                
                print(lastName + ", " + firstName)
                
                completionHandlerForUserData(true, nil)
            }
            
        }
    }
    
    private func deleteLoginToken(_ completionHandlerForDeleteToken: @escaping (_ success: Bool, _ error: NSError?) -> Void ) {
        
        udacityDELETETaskWith(urlMethod: UdacityClient.Methods.session) { (results, error) in
            
            func sendError(_ errorString: String) {
                completionHandlerForDeleteToken(false, NSError(domain: "udacityDELETETaskWith", code: 1, userInfo: [NSLocalizedDescriptionKey: errorString]))
            }
            
            if error != nil {
                sendError(error?.localizedDescription ?? "An unknown error occured")
                return
            }
            
            if results == nil {
                sendError(error?.localizedDescription ?? "An unknown error occured")
                return
            }
            
            completionHandlerForDeleteToken(true, nil)
            
        }
    }
    
    private func getFacebookLoginToken(_ completionHandlerForFacebookToken: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        udacityFBPOSTRequestWith(urlMethod: UdacityClient.Methods.session) { (results, error) in
            
            func sendError(_ errorString: String) {
                completionHandlerForFacebookToken(false, NSError(domain: "getFacebookLoginToken", code: 1, userInfo: [NSLocalizedDescriptionKey : errorString]))
            }
            
            if error != nil || results == nil {
                sendError(error?.localizedDescription ?? "An unknown error occured")
            } else {
                guard let account = results?["account"] as? [String: AnyObject] else {
                    completionHandlerForFacebookToken(false, NSError(domain: "getAccountKey", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to get account info from parsed Json data"]))
                    return
                }
                
                if let key = account["key"] as? String {
                    UdacityClient.shared.userId = key
                } else {
                    completionHandlerForFacebookToken(false, NSError(domain: "getAccountKey", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to get account key from parsed Json data"]))
                }
            }
            
            completionHandlerForFacebookToken(true, nil)
            
        }
    }
}

