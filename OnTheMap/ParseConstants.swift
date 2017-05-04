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
    }
    
    struct HTTPHeaderValues {
        static let ApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct URLParameterKeys {
        static let Limit = "limit"
        static let Order = "order"
        static let Skip = "skip"
    }
    
    struct URLParameterValues {
        static let Limit = "200"
        static let Skip = "400"
        static let Order = "updatedAt"
    }
    
    
}
