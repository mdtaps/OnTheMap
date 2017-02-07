//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Worship Computer on 2/5/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient: NSObject {
    
    static var shared = UdacityClient()

    let session = URLSession.shared
    
    var userEmail: String?
    var password: String?
    
    func udacityPostTask(_ completionHandlerForPost: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        func sendError(_ error: String) {
            let userInfo = [NSLocalizedDescriptionKey: error]
            completionHandlerForPost(nil, NSError(domain: "udacityPostTask", code: 1, userInfo: userInfo))
        }
        
        guard let request = udacityUrlRequest() else {
            sendError("Unable to create URL Request")
            return
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard error != nil else {
                sendError("The data returned an error")
                return
            }
            
            
        }
        
        task.resume()
    }
    
    private func udacityUrlRequest() -> NSMutableURLRequest? {
        
        let url = udacityUrl()
        let request = NSMutableURLRequest(url: url)
        
        let headers = [
            UdacityClient.HTTPHeaderKey.Accept: UdacityClient.HTTPHeaderValue.ApplicationJson,
            UdacityClient.HTTPHeaderKey.ContentType: UdacityClient.HTTPHeaderValue.ApplicationJson]
        
        guard let userEmail = userEmail, let password = password else {
            //TODO: Error Handling
            return nil
        }
        
        let authenticationDict: [String: String] = [
            "username": userEmail,
            "password": password
        ]
        
        let postBody: [String: AnyObject] = [
            "udacity": authenticationDict as AnyObject]
        
        request.allHTTPHeaderFields = headers
        request.httpBody = GeneralNetworkingClient.shared.jsonDataFromJsonObject(postBody)
        request.httpMethod = "POST"
        
        return request
    }
    
    private func udacityUrl() -> URL {
        var components = URLComponents()
        components.scheme = UdacityClient.APIConstants.ApiScheme
        components.host = UdacityClient.APIConstants.ApiHost
        components.path = UdacityClient.APIConstants.ApiPath
        
        return components.url!
    }
}
