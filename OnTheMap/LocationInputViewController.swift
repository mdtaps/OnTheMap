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
    
    var placemark: CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationTextField.becomeFirstResponder()
    }
    
    @IBAction func dropPin() {
        
        guard let locationText = locationTextField.text else {
            //TO DO: Call error pop-up
            return
        }
        
        createLocationFromString(locationString: locationText)
        
        if let linkVC = self.storyboard?.instantiateViewController(withIdentifier: "linkInput") as? LinkInputViewController {
            linkVC.placemark = placemark
            
            present(linkVC, animated: true, completion: nil)
        }
    }
    
    private func createLocationFromString(locationString: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString) { (placemarkDict, error) in
            guard error == nil else {
                //TO DO: Call error pop-up
                return
            }
            
            guard placemarkDict != nil else {
                //TO DO: Call error pop-up
                return
            }
            
            if let placemark = placemarkDict?[0] {
                self.placemark = placemark
            }
        }
    }
    
    
}
