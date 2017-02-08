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
    var userId: String?
    
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
            
            guard error == nil else {
                sendError("The data returned an error")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                if statusCode >= 400 && statusCode < 500 {
                    sendError("Incorrect Email or Password")
                    return
                }
                
                if statusCode < 200 || statusCode >= 300 {
                    sendError("Status code returned something other than 2xx: \(statusCode)")
                    return
                }

            } else {
                sendError("Status code from server could not be found")
            }
            
            guard let data = data else {
                sendError("No data returned by request")
                return
            }
            
            let newData = self.udacityCorrectedData(data)
            
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
            guard let parsedData = GeneralNetworkingClient.shared.jsonObjectFromJsonData(newData) else {
                sendError("Error parsing Json data")
                return
            }
            
            completionHandlerForPost(parsedData, nil)
        }
        
        task.resume()
    }
    
    //Private Functions
    private func udacityUrlRequest() -> NSMutableURLRequest? {
        
        let url = udacityUrl()
        let request = NSMutableURLRequest(url: url)
        
        let headers = [
            UdacityClient.HTTPHeaderKey.Accept: UdacityClient.HTTPHeaderValue.ApplicationJson,
            UdacityClient.HTTPHeaderKey.ContentType: UdacityClient.HTTPHeaderValue.ApplicationJson]

        guard let userEmail = userEmail, let password = password else {
            return nil
        }
        
        let postBody: [String: AnyObject] = ["udacity": [
            "username": userEmail,
            "password": password] as AnyObject]
                
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
    
    private func udacityCorrectedData(_ data: Data) -> Data {
        let range = Range(uncheckedBounds: (5, data.count))
        let newData = data.subdata(in: range)
        
        return newData
    }
}
