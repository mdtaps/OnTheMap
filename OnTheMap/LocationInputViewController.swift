//
//  LocationInputViewController.swift
//  OnTheMap
//
//  Created by Mark Daniel TApia on 3/4/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import UIKit
import CoreLocation

@IBDesignable
class LocationInputViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet var locationInputView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var duplicateExists = false
    
    var mapVC: MapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Hide border under navBar
        let img = UIImage()
        
        self.navigationBar.shadowImage = img
        self.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func dismissModalViewController(_ sender: UIBarButtonItem) {
        mapVC?.dismissModalViewControllers()
    }
    
    
    @IBAction func dropPin() {
        
        guard let locationText = locationTextField.text else {
            //TO DO: Call error pop-up
            print("Location Text failing")
            return
        }
        
        createLocationFromString(locationString: locationText) { (coordinate, locality, error) in
            
            guard error == nil else {
                let errorString = error?.localizedDescription ?? "An unknown error occured"
                
                self.displayError(message: errorString)
                return
            }
            
            guard coordinate != nil else {
                self.displayError(message: "No coordinate exists")
                return
            }
            
            if let linkVC = self.storyboard?.instantiateViewController(withIdentifier: "linkInput") as? LinkInputViewController {
                
                linkVC.coordinate = coordinate!
                linkVC.locality = locality ?? "Location Unknown"
                linkVC.duplicateExists = self.duplicateExists
                linkVC.mapVC = self.mapVC
                
                
                performUIUpdatesOnMain {
                    self.present(linkVC, animated: true, completion: nil)
                }
            }
        }
    }
}


extension LocationInputViewController {
    
    //Respond to Taps
    @IBAction func unselectTextField(handler: UITapGestureRecognizer) {
        
        locationTextField.resignFirstResponder()
    }
    
    //Respond to Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if view.frame.origin.y == 0 {
        
                view.frame.origin.y -= keyboardSize.height - CGFloat()
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let buttonKeyboardGap: CGFloat = 42.5
            
            view.frame.origin.y -= keyboardSize.height - buttonKeyboardGap
            
            if view.frame.origin.y != 0 {
                view.frame.origin.y = 0
            }
        }
    }
    
    //Displaying Error Alert
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "Dismiss", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.preferredAction = action
        
        present(alert, animated: true, completion: nil)
    }

}
