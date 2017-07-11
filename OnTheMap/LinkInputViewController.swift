//
//  LinkInputViewController.swift
//  OnTheMap
//
//  Created by Lindsey Renee Eaton on 3/13/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class LinkInputViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var coordinate = CLLocationCoordinate2D()
    var locality = ""
    
    var mapVC: PinViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let point = MKPointAnnotation()
        
        point.coordinate = coordinate
        point.title = locality
        
        mapView.addAnnotation(point)
        
        //Hide border under navBar
        let img = UIImage()
        
        self.navigationBar.shadowImage = img
        self.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    
    @IBAction func dismissModalViewController(_ sender: UIBarButtonItem) {
        mapVC?.dismissModalViewControllers()
    }
    
    @IBAction func submitButtonPressed() {
        
        let pinData: [String: AnyObject] = [
            "latitude":     coordinate.latitude as AnyObject,
            "longitude":    coordinate.longitude as AnyObject,
            "uniqueKey":    UdacityClient.shared.userId! as AnyObject,
            "firstName":    (UdacityClient.shared.userFirstName ?? "Unknown") as AnyObject,
            "lastName":     (UdacityClient.shared.userLastName ?? "Unknown") as AnyObject,
            "mapString":    locality as AnyObject,
            "mediaURL":     (urlTextField.text ?? "https://www.udacity.com") as AnyObject]
        
        ParseClient.shared.submitUserPinData(pinData: pinData,
                                             overwriteDuplicate: ParseClient.shared.duplicateExists)
        { (success, errorString) in
                
                if !success {
                    performUIUpdatesOnMain {
                        self.displayAlert(title: "Posting Failed", message: errorString ?? "An unknown error occured")
                    }
                } else {
                    print("Success posting user pin to server!")
                    performUIUpdatesOnMain {
                        self.mapVC?.dismissModalViewControllers()
                    }
                }
        }
    }
    
    //TODO: Fix the dismisal of Modal Views
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: dismissInputViewControllers)
        
        alert.addAction(action)
        alert.preferredAction = action
        
        present(alert, animated: true, completion: nil)
    }
    
    func dismissInputViewControllers(_: UIAlertAction) {
        self.mapVC?.dismissModalViewControllers()
    }
    
}
