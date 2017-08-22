//
//  FacebookLogin.swift
//  OnTheMap
//
//  Created by Mark Tapia on 7/29/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit

extension UdacityLoginViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        switch result {
        case let .success(_, _, token):
            UdacityClient.shared.facebookAccessToken = token.authenticationToken
            
            let connection = GraphRequestConnection()
            connection.add(MyProfileRequest()) { response, result in
                switch result {
                case .success(let graphResponse):
                    UdacityClient.shared.userFirstName = graphResponse.firstName ?? "Unknown"
                    UdacityClient.shared.userLastName = graphResponse.lastName ?? "Unknown"
                case .failed(let error):
                    print("Custom Graph Request Failed: \(error)")
                }
            }
            connection.start()
            
            UdacityClient.shared.userFirstName = UserProfile.current?.firstName ?? "Unknown"
            UdacityClient.shared.userLastName = UserProfile.current?.lastName ?? "Unknown"
            
            dump(UserProfile.current?.firstName)
            
            UdacityClient.shared.loginWithFacebook() { (success, errorString) in
                if let errorString = errorString {
                    self.displayAlert(title: "Login Failed", message: errorString)
                    return
                }
                
                if success {
                    ParseClient.shared.populateStudentPins { (success, errorString) in
                        if let errorString = errorString {
                            self.displayAlert(title: "Student Pins Failed", message: errorString)
                            return
                        }
                        
                        if success {
                            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MapTabBarController") {
                                UdacityClient.shared.loginMethod = .Facebook
                                UdacityClient.shared.udacityLoginScreen = self
                                performUIUpdatesOnMain {
                                    self.present(viewController, animated: true, completion: {
                                        ActivityIndicator.end(view: self.view)
                                        self.passwordField.text = ""
                                    })
                                }
                                
                            }
                        }
                    }
                }
            }
            
        default:
            displayAlert(title: "Facebook Login Failed",
                         message: "Facebook Login returned an error")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        
    }
    
    func logoutPressedWhenLoggedInWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logOut()
    }
}

extension UdacityLoginViewController {
    func setupFacebookButton() {
        NSLayoutConstraint(item: facebookLoginButton,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerXWithinMargins,
                           multiplier: 1.0,
                           constant: 0)
            .isActive = true
        
        NSLayoutConstraint(item: facebookLoginButton,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .leading,
                           multiplier: 1.0,
                           constant: 20)
            .isActive = true
        
        NSLayoutConstraint(item: facebookLoginButton,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: -20)
            .isActive = true
        
        NSLayoutConstraint(item: facebookLoginButton,
                           attribute: .trailing,
                           relatedBy: .equal,
                           toItem: view,
                           attribute: .trailing,
                           multiplier: 1.0,
                           constant: -20)
            .isActive = true
        
        facebookLoginButton.delegate = self
    }
}

struct MyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        
        var firstName: String?
        var lastName: String?

        init(rawResponse: Any?) {
            guard let response = rawResponse as? [String: Any] else {
                return
            }
            
            if let firstName = response["first_name"] as? String {
                self.firstName = firstName
            }
            
            if let lastName = response["last_name"] as? String {
                self.lastName = lastName
            }
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, first_name, last_name"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}

