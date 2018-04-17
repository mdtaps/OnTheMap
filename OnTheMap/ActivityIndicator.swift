//
//  ActivityIndicator.swift
//  OnTheMap
//
//  Created by Mark Tapia on 4/16/18.
//  Copyright © 2018 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator {
    
        static var width: CGFloat {
            
            let screenWidth = UIScreen.main.bounds.width
            return screenWidth / 3 - 10
        }
        static var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: width, height: width))
    
        static func getActivityIndicator() -> UIActivityIndicatorView {
            setupActivityIndicator()
            return activityIndicator
        }

        private static func setupActivityIndicator() {
            let backgroundColor = UIColor.darkGray
            
            activityIndicator.hidesWhenStopped = true
            activityIndicator.backgroundColor = backgroundColor
            activityIndicator.layer.cornerRadius = 7
            activityIndicator.startAnimating()
            
        }
}
