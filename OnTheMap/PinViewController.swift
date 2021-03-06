//
//  PinViewController.swift
//  OnTheMap
//
//  Created by Lindsey Renee Eaton on 7/10/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import UIKit

class PinViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutButton = UIBarButtonItem(title: "Logout",
                                           style: .done,
                                           target: self,
                                           action: #selector(logoutPressed(_:)))
        
        let addPinButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Pin"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(addPin(_:)))


        self.navigationItem.title = "On The Map"
        self.navigationItem.leftBarButtonItem = logoutButton
        self.navigationItem.rightBarButtonItem = addPinButton
    }
    
    
    
    //MARK: Pin adding process
    func addPin(_ sender: AnyObject) {
        print("add pin pressed")
        //Check for user already in existence
        if UdacityClient.shared.userId != nil {
            for pin in StudentPins.sharedInstance {
                if pin.uniqueKey == UdacityClient.shared.userId {
                    ParseClient.shared.duplicateExists = true
                    ParseClient.shared.userObjectId = pin.objectId
                    print("Duplicate found")
                    break
                }
            }
            
            if ParseClient.shared.duplicateExists {
                self.displayDuplicateAlert()
            } else {
                launchPinAddingProcess(UIAlertAction())
            }
        } else {
            displayAlert(title: "No User ID", message: "User ID not set")
        }
    }
    
    func launchPinAddingProcess(_: UIAlertAction) {
        
        if let locationVC = self.storyboard?.instantiateViewController(withIdentifier: "locationInputVC") as? LocationInputViewController {
            
            locationVC.mapVC = self
            
            present(locationVC, animated: true)
        }
    }
    
    func logoutPressed(_ sender: AnyObject) {
        ActivityIndicator.activityIndicator.startAnimating()
        UdacityClient.shared.logoutFromUdacity { (success, error) in
            performUIUpdatesOnMain {
                ActivityIndicator.activityIndicator.startAnimating()
            }
            if let error = error {
                self.displayAlert(title: "Logout Failure", message: error)
            } else {
                if success {
                    performUIUpdatesOnMain {
                        self.dismiss(animated: true) {
                            if UdacityClient.shared.loginMethod == .Facebook {
                                if let loginScreen = UdacityClient.shared.udacityLoginScreen {
                                    loginScreen.logoutPressedWhenLoggedInWithFacebook()
                                } else {
                                    self.displayAlert(title: "Facebook Logout Failed", message: "Facebook was unable to log out")
                                }
                                
                            }
                            
                        }
                    }
                } else {
                    self.displayAlert(title: "Logout Failure", message: "Logout caused an error")
                }
            }
        }
    }
    
    fileprivate func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        
        alert.addAction(action)
        alert.preferredAction = action
        
        performUIUpdatesOnMain {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func displayDuplicateAlert() {
        let alert = UIAlertController(title: "Duplicate Pin Found",
                                      message: "You have already posted a student loction. Would you like to overwrite your location?", preferredStyle: .alert)
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default, handler: launchPinAddingProcess)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(overwriteAction)
        alert.addAction(cancelAction)
        
        alert.preferredAction = overwriteAction
        
        present(alert, animated: true, completion: nil)
    }
    
    //Function to dismiss modal view controllers
    func dismissModalViewControllers(withViewUpdate updateView: Bool) {
        
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        if updateView {
            
            ParseClient.shared.populateStudentPins { (success, errorString) in
                if let errorString = errorString {
                    performUIUpdatesOnMain {
                        self.displayAlert(title: "Student Pins Failed", message: errorString)
                    }
                    return
                }
                
                if !success {
                    self.displayAlert(title: "Error", message: "An unknown error occured while populating pins")
                    return
                }
            }
            updatePinViews()
        }
    }
    
    func updatePinViews() {
        if let vc = self as? MapViewController {
            vc.populatePointAnnotationsFrom(studentData: StudentPins.sharedInstance)
        } else if let vc = self as? UsersTableViewController {
            vc.usersTableView.reloadData()
        }
    }
}


extension PinViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        updatePinViews()
    }
}
