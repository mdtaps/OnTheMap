//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Worship Computer on 2/3/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

class ParseClient: NSObject {
    
    static let shared = ParseClient()
    
    let session = URLSession.shared
    
    var userObjectId = ""
    var duplicateExists = false
    
    //GET Tasks
    func parseGETTask(_ completingHandlerForGET: @escaping (_ parsedData: AnyObject?, _ error: NSError?) -> Void) {
        
        func sendError(errorString: String) {
            completingHandlerForGET(nil, NSError(domain: "parseGETTask", code: 1, userInfo: [NSLocalizedDescriptionKey: errorString]))
        }
        
        let parameters = [
            ParseClient.URLParameterKeys.Limit: ParseClient.URLParameterValues.Limit,
            ParseClient.URLParameterKeys.Order: ParseClient.URLParameterValues.Order]
        
        guard let request = parseGETrequest(parameters: parameters) else {
            sendError(errorString: "Error with returning URL request")
            return
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard GeneralNetworkingClient.shared.checkTask(error: error) else {
                print(error!.localizedDescription)
                sendError(errorString: error?.localizedDescription ?? "Data returned an error")
                return
            }
            
            guard GeneralNetworkingClient.shared.checkTask(response: response) else {
                let statusCode: Int? = (response as? HTTPURLResponse)?.statusCode
                sendError(errorString: "Server returned response: \(String(describing: statusCode))")
                return
            }
            
            guard GeneralNetworkingClient.shared.checkTask(data: data) else {
                sendError(errorString: "No data returned with request")
                return
            }
            
            guard let parsedData = GeneralNetworkingClient.shared.jsonObjectFromJsonData(data!) else {
                sendError(errorString: "Error parsing JSON data")
                return
            }
            
            completingHandlerForGET(parsedData, nil)
        }
        
        task.resume()
    }
    
    func parseGETrequest(parameters: [String: String]) -> URLRequest? {
        
        guard let url = parseUrlWithParameters(parameters) else {
            return nil
        }
        
        guard let request = parseMutableUrlRequestWith(url) else {
            return nil
        }
        
        return request as URLRequest
    }
    
    //POST Tasks
    func parsePOSTTask(jsonObject: [String: AnyObject], _ completingHandlerForPOST: @escaping (_ postSuccessful: Bool, _ error: NSError?) -> Void) {
        
        func sendError(errorString: String) {
            completingHandlerForPOST(false, NSError(domain: "parsePOSTTask", code: 1, userInfo: [NSLocalizedDescriptionKey: errorString]))
        }
        
        guard let request = parsePOSTRequest(jsonObject) else {
            sendError(errorString: "Error with returning URL request")
            return
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard GeneralNetworkingClient.shared.checkTask(error: error) else {
                print(error!.localizedDescription)
                sendError(errorString: error?.localizedDescription ?? "Data returned an error")
                return
            }
            
            guard GeneralNetworkingClient.shared.checkTask(response: response) else {
                let statusCode: Int? = (response as? HTTPURLResponse)?.statusCode
                sendError(errorString: "Server returned response: \(String(describing: statusCode))")
                return
            }
            
            guard GeneralNetworkingClient.shared.checkTask(data: data) else {
                sendError(errorString: "No data returned with request")
                return
            }
            
            completingHandlerForPOST(true, nil)
        }
        
        task.resume()
    }
    
    func parsePOSTRequest(_ jsonObject: [String: AnyObject]) -> URLRequest? {
        
        guard let url = parseUrlWithParameters([:]) else {
            return nil
        }
        
        guard let request = parseMutableUrlRequestWith(url) else {
            return nil
        }
        
        request.httpMethod = "POST"
        request.httpBody = GeneralNetworkingClient.shared.jsonDataFromJsonObject(jsonObject)
        request.addValue(HTTPHeaderValues.ContentType, forHTTPHeaderField: HTTPHeaderKeys.ContentType)

        
        return request as URLRequest
    }
    
    //PUT Task
    func parsePUTTask(jsonObject: [String: AnyObject], _ completingHandlerForPUT: @escaping (_ postSuccessful: Bool, _ error: NSError?) -> Void) {
        
        print("Put Task")
        
        func sendError(errorString: String) {
            completingHandlerForPUT(false, NSError(domain: "parsePUTTask", code: 1, userInfo: [NSLocalizedDescriptionKey: errorString]))
        }
        
        guard let request = parsePUTRequest(jsonObject) else {
            sendError(errorString: "Error with returning URL request")
            return
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard GeneralNetworkingClient.shared.checkTask(error: error) else {
                print(error!.localizedDescription)
                sendError(errorString: error?.localizedDescription ?? "Data returned an error")
                return
            }
            
            guard GeneralNetworkingClient.shared.checkTask(response: response) else {
                let statusCode: Int? = (response as? HTTPURLResponse)?.statusCode
                sendError(errorString: "Server returned response: \(String(describing: statusCode))")
                return
            }
            
            guard GeneralNetworkingClient.shared.checkTask(data: data) else {
                sendError(errorString: "No data returned with request")
                return
            }
            
            completingHandlerForPUT(true, nil)
        }
        
        task.resume()
    }
    
    func parsePUTRequest(_ jsonObject: [String: AnyObject]) -> URLRequest? {
        
        guard var url = parseUrlWithParameters([:]) else {
            return nil
        }
        
        url.appendPathComponent("/\(ParseClient.shared.userObjectId)")
        
        print("\(url.absoluteString)")
        
        guard let request = parseMutableUrlRequestWith(url) else {
            return nil
        }
        
        request.httpMethod = ParseClient.HTTPMethod.Put
        request.httpBody = GeneralNetworkingClient.shared.jsonDataFromJsonObject(jsonObject)
        request.addValue(HTTPHeaderValues.ContentType, forHTTPHeaderField: HTTPHeaderKeys.ContentType)
        
        return request as URLRequest
    }
}
