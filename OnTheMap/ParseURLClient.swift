//
//  ParseURLClient.swift
//  OnTheMap
//
//  Created by Lindsey Renee Eaton on 5/22/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation

extension ParseClient {
    //Parsing URL
    func parseUrlWithParameters(_ parameters: [String: String]) -> URL? {
        
        var components = URLComponents()
        components.scheme = APIConstants.ApiScheme
        components.host = APIConstants.ApiHost
        components.path = APIConstants.ApiPath
        var queryItems = [URLQueryItem]()
        
        if !parameters.isEmpty {
            for pairs in parameters {
                queryItems.append(URLQueryItem(name: pairs.key, value: pairs.value))
            }
            
            components.queryItems = queryItems
        }
        
        return components.url
    }
    
    //Add Header Values to request
    func parseMutableUrlRequestWith(_ url: URL) -> NSMutableURLRequest? {
        
        let request = NSMutableURLRequest(url: url)
        request.addValue(HTTPHeaderValues.ApiKey, forHTTPHeaderField: HTTPHeaderKeys.ApiKey)
        request.addValue(HTTPHeaderValues.ApplicationId, forHTTPHeaderField: HTTPHeaderKeys.ApplicationId)
        
        return request
    }

}
