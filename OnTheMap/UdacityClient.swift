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
    
    var userFirstName: String?
    var userLastName: String?
    var objectId: String?
    
    func udacityPOSTTaskWith(method: String, _ completionHandlerForPOST: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        func sendError(_ error: String) {
            let userInfo = [NSLocalizedDescriptionKey: error]
            completionHandlerForPOST(nil, NSError(domain: "udacityPOSTTaskWith", code: 1, userInfo: userInfo))
        }
        
        guard let request = udacityUrlPOSTRequestWith(method: method) else {
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
            
            guard let parsedData = GeneralNetworkingClient.shared.jsonObjectFromJsonData(newData) else {
                sendError("Error parsing Json data")
                return
            }
            
            print(parsedData)
            
            completionHandlerForPOST(parsedData, nil)
        }
        
        task.resume()
    }
    
    func udacityGETTaskWith(urlMethod: String, completionHandlerForGET: @escaping (AnyObject?, _ error: NSError?) -> Void) {
        
        func sendError(error: String) {
            completionHandlerForGET(nil, NSError(domain: "udacityGETTaskWith", code: 1, userInfo: [NSLocalizedDescriptionKey: error]))
        }
        
        guard let request = udacityUrlGETRequestWith(method: urlMethod) else {
            sendError(error: "Failed to create URL request")
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
            
            completionHandlerForGET(parsedData, nil)
        }
        
        task.resume()
    }
    
    func udacityDELETETaskWith(urlMethod: String, completionHandlerForDELETE: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) {
        
        func sendError(error: String) {
            completionHandlerForDELETE(nil, NSError(domain: "udacityDELETEaskWith", code: 1, userInfo: [NSLocalizedDescriptionKey: error]))
        }
        
        guard let request = udacityUrlDELETERequestWith(method: urlMethod) else {
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
            
            completionHandlerForDELETE(parsedData, nil)
        }
        
        task.resume()
    }
    
    //MARK: Private Functions
    private func udacityUrlGETRequestWith(method: String) -> NSMutableURLRequest? {
        
        let url = udacityUrl(pathExtension: method)
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "GET"
        
        
        
        return request
    }

    private func udacityUrlPOSTRequestWith(method: String) -> NSMutableURLRequest? {
        
        let url = udacityUrl(pathExtension: method)
        print("The url is : \(url.absoluteString)")
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
    
    private func udacityUrlDELETERequestWith(method: String) -> NSMutableURLRequest? {
        let url = udacityUrl(pathExtension: method)
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "DELETE"
        
        return request
    }
    
    private func udacityUrl(pathExtension: String) -> URL {
        var components = URLComponents()
        components.scheme = UdacityClient.APIConstants.ApiScheme
        components.host = UdacityClient.APIConstants.ApiHost
        components.path = UdacityClient.APIConstants.ApiPath + pathExtension
        
        return components.url!
    }
    
    private func udacityCorrectedData(_ data: Data) -> Data {
        let range = Range(uncheckedBounds: (5, data.count))
        let newData = data.subdata(in: range)
        
        return newData
    }
    
    private func addCookieValue(request: NSMutableURLRequest) -> NSMutableURLRequest? {
        var xsrfCookie: HTTPCookie? = nil
        
        var sharedCookieStorage = HTTPCookieStorage.shared
        guard let cookies = sharedCookieStorage.cookies else {
            print("Logout Failed")
            return nil
        }
        
        for cookie in cookies {
            if cookie.name == UdacityClient.CookieKeys.CookieName {
                xsrfCookie = cookie
                break
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: UdacityClient.HTTPHeaders.XSRFToken)
            return request
        } else {
            return nil
        }
    }
}
