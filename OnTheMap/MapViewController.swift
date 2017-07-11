//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Lindsey Renee Eaton on 2/19/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: PinViewController {

    @IBOutlet weak var mapView: MKMapView!
    var pointAnnotationsArray = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        populatePointAnnotationsFrom(studentData: ParseClient.shared.studentPins)
    }
        
    func populatePointAnnotationsFrom(studentData: [StudentInformation]) {
        
        mapView.removeAnnotations(mapView.annotations)
        pointAnnotationsArray.removeAll()
        print("populate called")
        
        for data in studentData {
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            pointAnnotation.title = data.firstName + " " + data.lastName
            pointAnnotation.subtitle = data.mediaUrl
            
            pointAnnotationsArray.append(pointAnnotation)
            
            mapView.addAnnotations(pointAnnotationsArray)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
        populatePointAnnotationsFrom(studentData: ParseClient.shared.studentPins)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.animatesDrop = true
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
}
