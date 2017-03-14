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
    
    var studentPins = [StudentInformation]()
    
    func parseGETTask(_ completingHandlerForGET: @escaping (_ parsedData: AnyObject?, _ error: NSError?) -> Void) {
        
        func sendError(errorString: String) {
            completingHandlerForGET(nil, NSError(domain: "parseGETTask", code: 1, userInfo: [NSLocalizedDescriptionKey: errorString]))
        }
        
        let parameters = [
            ParseClient.URLParameterKeys.Limit: ParseClient.URLParameterValues.Limit,
//            ParseClient.URLParameterKeys.Skip: ParseClient.URLParameterValues.Skip,
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
                sendError(errorString: "Server returned response: \(statusCode)")
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
    
    func parseUrlWithParameters(_ parameters: [String: String]) -> URL? {
        
        var components = URLComponents()
        components.scheme = APIConstants.ApiScheme
        components.host = APIConstants.ApiHost
        components.path = APIConstants.ApiPath
        var queryItems = [URLQueryItem]()
        
        for pairs in parameters {
            queryItems.append(URLQueryItem(name: pairs.key, value: pairs.value))
        }
        
        components.queryItems = queryItems
        
        return components.url
    }
    
    func parseMutableUrlRequestWith(_ url: URL) -> NSMutableURLRequest? {
        
        let request = NSMutableURLRequest(url: url)
        request.addValue(HTTPHeaderValues.ApiKey, forHTTPHeaderField: HTTPHeaderKeys.ApiKey)
        request.addValue(HTTPHeaderValues.ApplicationId, forHTTPHeaderField: HTTPHeaderKeys.ApplicationId)
        
        return request
    }
 }
