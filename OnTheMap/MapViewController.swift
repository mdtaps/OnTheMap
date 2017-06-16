//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Lindsey Renee Eaton on 2/19/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var pointAnnotationsArray = [MKPointAnnotation]()
    
    var duplicateExists = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewdidappear")
        
        populatePointAnnotationsFrom(studentData: ParseClient.shared.studentPins)
    }
        
    func populatePointAnnotationsFrom(studentData: [StudentInformation]) {
        
        for data in studentData {
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            pointAnnotation.title = data.firstName + " " + data.lastName
            pointAnnotation.subtitle = data.mediaUrl
            
            pointAnnotationsArray.append(pointAnnotation)
            
            mapView.addAnnotations(pointAnnotationsArray)
        }
        
        print("Annotations populated")
        
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
        print("map loaded")
        
        populatePointAnnotationsFrom(studentData: ParseClient.shared.studentPins)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let app = UIApplication.shared

        guard let toOpen = view.annotation?.subtitle else {
            return
        }
        
        guard let url = URL(string: toOpen!) else {
            return
        }
        
        app.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func refreshPins(_ sender: UIBarButtonItem) {
        
        ActivityIndicator.start(view: view)
        
        UdacityClient.shared.populatePersonalData { (success, error) in
            
            ActivityIndicator.end(view: self.view)
            
            if let error = error {
                self.displayAlert(title: "Something Went Wrong", message: error)
            } else if success {
                self.populatePointAnnotationsFrom(studentData: ParseClient.shared.studentPins)
            }
        }
    }
    
    @IBAction func addPin(_ sender: UIBarButtonItem) {
        
        //Check for user already in existence
        if UdacityClient.shared.userId != nil {
            for pin in ParseClient.shared.studentPins {
                if pin.uniqueKey == UdacityClient.shared.userId {
                    duplicateExists = true
                    ParseClient.shared.userObjectId = pin.objectId
                    print("Duplicate found")
                    break
                }
            }
            
            if duplicateExists {
                displayDuplicateAlert()
            } else {
                startPinAddingProcess(UIAlertAction())
            }
        }
    }
    
    func startPinAddingProcess(_: UIAlertAction) {
        
        if let locationVC = self.storyboard?.instantiateViewController(withIdentifier: "locationInputVC") as? LocationInputViewController {
            
            locationVC.duplicateExists = duplicateExists
            locationVC.mapVC = self
            
            present(locationVC, animated: true)
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        
        alert.addAction(action)
        alert.preferredAction = action
        
        present(alert, animated: true, completion: nil)
    }
    
    func displayDuplicateAlert() {
        let alert = UIAlertController(title: "Duplicate Pin Found",
                                      message: "You have already posted a student loction. Would you like to overwrite your location?", preferredStyle: .alert)
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default, handler: startPinAddingProcess)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(overwriteAction)
        alert.addAction(cancelAction)
        
        alert.preferredAction = overwriteAction
        
        present(alert, animated: true, completion: nil)
    }
    
    //Function to dismiss modal view controllers
    func dismissModalViewControllers() {
        dismiss(animated: true, completion: nil)
    }

}
