//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Worship Computer on 2/3/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    struct APIConstants {        
        //MARK: URL
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
    }
    
    struct HTTPHeaderKeys {
        static let ApplicationId = "X-Parse-Application-Id"
        static let ApiKey = "X-Parse-REST-API-Key"
        static let ContentType = "Content-Type"
    }
    
    struct HTTPHeaderValues {
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        //Public Parse API Key given by Udacity
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ContentType = "application/json"
    }
    
    struct HTTPMethod {
        static let Post = "POST"
        static let Put = "PUT"
    }
    
    struct URLParameterKeys {
        static let Limit = "limit"
        static let Order = "order"
        static let Skip = "skip"
    }
    
    struct URLParameterValues {
        static let Limit = "100"
        static let Order = "-updatedAt"
    }
    
    
}
