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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
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
        
        UdacityClient.shared.populatePersonalData { (success, error) in
            if let error = error {
                print(error)
            } else if success {
                self.populatePointAnnotationsFrom(studentData: ParseClient.shared.studentPins)
            }
        }
    }
    
/*    @IBAction func addPin(_ sender: UIBarButtonItem) {
        
        //TO DO: Check for user already in existence
        if let locationVC = self.storyboard?.instantiateViewController(withIdentifier: "locationInputVC") as? LocationInputViewController {
            
            self.navigationController?.pushViewController(locationVC, animated: true)
        }
        

    } */
    
    
}
