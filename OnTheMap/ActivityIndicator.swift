//
//  ActivityIndicator.swift
//  OnTheMap
//
//  Created by Lindsey Renee Eaton on 6/13/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator {
    
    static var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    static func start(view: UIView) {
        performUIUpdatesOnMain {
            setupActivityIndicator(view: view)
            view.addSubview(activityIndicator)
        }
    }
    
    static func end(view:UIView) {
        performUIUpdatesOnMain {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    private static func setupActivityIndicator(view: UIView) {
        var backgroundColor = UIColor.lightGray
        backgroundColor = backgroundColor.withAlphaComponent(0.7)
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.backgroundColor = backgroundColor
        activityIndicator.layer.cornerRadius = 7
        activityIndicator.startAnimating()
    }
    
}
