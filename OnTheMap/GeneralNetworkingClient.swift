//
//  GeneralNetworkingClient.swift
//  OnTheMap
//
//  Created by Worship Computer on 2/6/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

class GeneralNetworkingClient: NSObject {
    
    static var shared = GeneralNetworkingClient()
    
    func jsonDataFromJsonObject(_ object: [String:AnyObject]) -> Data? {
        
        let jsonData: Data?
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
        } catch {
            return nil
        }
        
        return jsonData
    }
    
    
    
}
