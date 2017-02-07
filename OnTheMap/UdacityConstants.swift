//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Worship Computer on 2/5/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    struct APIConstants {
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api/session"
    }
    
    struct HTTPHeaderKey {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }
    
    struct HTTPHeaderValue {
        static let ApplicationJson = "application/json"
    }
}
