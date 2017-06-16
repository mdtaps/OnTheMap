//
//  ViewController.swift
//  OnTheMap
//
//  Created by Worship Computer on 2/2/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import UIKit

class UdacityLoginViewController: UIViewController, UITextFieldDelegate {
    
    
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
                print("success!!!")
                self.completeLogin()
            } else {
                performUIUpdatesOnMain {
                    self.displayAlert(title: "Error", message: errorString!)
                }
            }
        }
    }
    
    private func completeLogin() {
        UdacityClient.shared.populatePersonalData() { ( success, error) in
            if let error = error {
                performUIUpdatesOnMain {
                    self.displayAlert(title: "Error", message: error)
                }
            }
            
            if success {
                print("Personal Data collected!")
            } else {
                self.displayAlert(title: "Error", message: "Request did not succeed")
            }
        }
        
        ParseClient.shared.populateStudentPins { (success, errorString) in
            if let errorString = errorString {
                //TO DO: Error Alert
                print(errorString)
            }
            
            if success {
                print("Successfully populated student pins")
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MapTabBarController") {
                    performUIUpdatesOnMain {
                        ActivityIndicator.end(view: self.view)
                        self.present(viewController, animated: true, completion: nil)
                    }
                    
                }
            }
        }
    }

    private func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.preferredAction = action
        
        present(alert, animated: true, completion: nil)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.isSecureTextEntry = true
    }
    
    

}

