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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        guard let email = emailField.text,
            let password = passwordField.text else {
                displayError(error: "Error in text fields")
                return
        }
        
        if email.isEmpty || password.isEmpty {
            displayError(error: "Please fill in both email and password")
            return
        }
        
        
        UdacityClient.shared.authenticateWithCredentials(email, password) { (success, errorString) in
            if success {
                print("success!!!")
                self.completeLogin()
            } else {
                performUIUpdatesOnMain {
                    self.displayError(error: errorString!)
                }
            }
        }
    }
    
    private func completeLogin() {
        
    }

    private func displayError(error: String) {
        print(error)
        debugTextLabel.text = error
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.isSecureTextEntry = true
    }

}

