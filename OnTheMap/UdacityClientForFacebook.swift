//
//  UdacityClientForFacebook.swift
//  OnTheMap
//
//  Created by Lindsey Renee Eaton on 7/18/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func udacityFBPOSTRequestWith(urlMethod: String, completionHandlerForFBPOST: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        func sendError(error: String) {
            completionHandlerForFBPOST(nil, NSError(domain: "udacityFBPOSTRequestWith", code: 1, userInfo: [NSLocalizedDescriptionKey: error]))
        }
        
        guard let request = udacityUrlFbPOSTRequestWith(method: urlMethod) else {
            sendError(error: "Failed to create Logout request")
            return
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard GeneralNetworkingClient.shared.checkTask(error: error) else {
                sendError(error: error!.localizedDescription)
                return
            }
            
            guard GeneralNetworkingClient.shared.checkTask(response: response) else {
                sendError(error: "Status code returned something other than 2xx")
                return
            }
            
            guard GeneralNetworkingClient.shared.checkTask(data: data) else {
                sendError(error: "No data returned with request")
                return
            }
            
            let newData = self.udacityCorrectedData(data!)
            
            guard let parsedData = GeneralNetworkingClient.shared.jsonObjectFromJsonData(newData) else {
                sendError(error: "Error parsing Json data")
                return
            }
            
            completionHandlerForFBPOST(parsedData, nil) 
        }
        
        task.resume()
        
    }
    
    private func udacityUrlFbPOSTRequestWith(method: String) -> NSMutableURLRequest? {
        let url = udacityUrl(pathExtension: method)
        let request = NSMutableURLRequest(url: url)
        
        let headers = [
            UdacityClient.HTTPHeaderKey.Accept: UdacityClient.HTTPHeaderValue.ApplicationJson,
            UdacityClient.HTTPHeaderKey.ContentType: UdacityClient.HTTPHeaderValue.ApplicationJson]
        
        guard let facebookAccessToken = UdacityClient.shared.facebookAccessToken else {
            return nil
        }
        
        let postBody: [String : AnyObject] = [
            "facebook_mobile": [
                "access_token" : facebookAccessToken] as AnyObject]
        
        request.allHTTPHeaderFields = headers
        request.httpBody = GeneralNetworkingClient.shared.jsonDataFromJsonObject(postBody)
        request.httpMethod = "POST"
        
        return request
    }
}
