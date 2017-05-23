//
//  LocationInputModel.swift
//  OnTheMap
//
//  Created by Lindsey Renee Eaton on 5/16/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation
import CoreLocation

extension LocationInputViewController {
    
    func createLocationFromString(locationString: String, _ completionHandlerFromLocationString: @escaping(_ coordinate: CLLocationCoordinate2D?, _ locality: String?, _ error: NSError?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(locationString) { (placemarkDict, error) in
            
            var coordinate: CLLocationCoordinate2D?
            var locality: String?
            
            func sendError(errorString: String) {
                completionHandlerFromLocationString(nil,
                                                    nil,
                                                    NSError(domain: "createLocationFromString", code: 1, userInfo: [NSLocalizedDescriptionKey: errorString])
                )
            }
            
            guard error == nil else {
                let errorString = error?.localizedDescription ?? "An error occured while getting address"
                sendError(errorString: errorString)
                return
            }
            
            guard placemarkDict != nil else {
                sendError(errorString: "Could not find a location from the name you provided")
                return
            }
            
            if let placemark = placemarkDict?[0] {
                
                if let location = placemark.location {
                    coordinate = location.coordinate
                } else {
                    sendError(errorString: "Creating location failed")
                    return
                }
                
                if let placemarkLocality = placemark.locality {
                    locality = placemarkLocality
                }
            }
            
            completionHandlerFromLocationString(coordinate, locality, nil)
        }
    }
}
