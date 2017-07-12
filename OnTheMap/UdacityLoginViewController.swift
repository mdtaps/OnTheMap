//
//  ViewController.swift
//  OnTheMap
//
//  Created by Worship Computer on 2/2/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import UIKit
import FacebookLogin

class UdacityLoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugTextLabel.text = ""
        passwordField.delegate = self
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        ActivityIndicator.start(view: view)
        
        guard let email = emailField.text,
            let password = passwordField.text else {
                displayAlert(title: "Error", message: "Error in text fields")
                return
        }
        
        if email.isEmpty || password.isEmpty {
            displayAlert(title: "Missing Credentials", message: "Please fill in both email and password")
            return
        }
        
        
        UdacityClient.shared.authenticateWithCredentials(email, password) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                performUIUpdatesOnMain {
                    self.displayAlert(title: "Error", message: errorString!)
                }
            }
        }
    }
    
    @IBAction func createUdacityAccount(_ sender: UIButton) {
        let app = UIApplication.shared
        
        let toOpenString = "https://www.udacity.com"
        
        guard let url = URL(string: toOpenString) else {
            return
        }
        
        app.open(url, options: [:], completionHandler: nil)
    }
}

//Text Field Delegate Function
extension UdacityLoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.isSecureTextEntry = true
    }
}

extension UdacityLoginViewController {
    
    fileprivate func completeLogin() {
        //Pull student data from server
        UdacityClient.shared.populatePersonalData() { ( success, error) in
            if let error = error {
                performUIUpdatesOnMain {
                    self.displayAlert(title: "Error", message: error)
                }
            }
            
            if !success {
                self.displayAlert(title: "Error", message: "Request did not succeed")
                return
            }
        }
        
        //Populate pins with student data
        ParseClient.shared.populateStudentPins { (success, errorString) in
            if let errorString = errorString {
                performUIUpdatesOnMain {
                    self.displayAlert(title: "Student Pins Failed", message: errorString)
                }
                return
            }
            
            if success {
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MapTabBarController") {
                    performUIUpdatesOnMain {
                        ActivityIndicator.end(view: self.view)
                        self.present(viewController, animated: true, completion: { 
                            self.passwordField.text = ""
                        })
                    }
                    
                }
            }
        }
    }
    
    //Function for displaying alert
    fileprivate func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.preferredAction = action
        
        present(alert, animated: true, completion: nil)
    }
}

