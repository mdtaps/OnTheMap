//
//  LocationInputViewController.swift
//  OnTheMap
//
//  Created by Mark Daniel TApia on 3/4/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import UIKit
import CoreLocation

class LocationInputViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet var locationInputView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var mapVC: PinViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Hide border line under navBar
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
        mapVC?.dismissModalViewControllers(withViewUpdate: false)
    }
    
    
    @IBAction func dropPin() {
        
        guard let locationText = locationTextField.text else {
            displayError(message: "Please enter text")
            return
        }
        
        ActivityIndicator.start(view: self.view)
        
        createLocationFromString(locationString: locationText) { (coordinate, locality, error) in
            
            ActivityIndicator.end(view: self.view)
            
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
                linkVC.mapVC = self.mapVC
                
                
                performUIUpdatesOnMain {
                    self.present(linkVC, animated: true, completion: nil)
                }
            }
        }
    }
}

extension LocationInputViewController {
    
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

extension LocationInputViewController: KeyboardResponder {
    
    var keyboardReferenceElement: UIView {
        return submitButton
    }

    //Respond to Taps
    @IBAction func unselectTextField(handler: UITapGestureRecognizer) {
        
        locationTextField.resignFirstResponder()
    }
    
    //Respond to Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            adjustViewWhenKeyboardShows(keyboardSize)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        adjustViewWhenKeyboardHides()
    }
}

