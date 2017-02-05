//
//  GCD.swift
//  OnTheMap
//
//  Created by Worship Computer on 2/3/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    
    DispatchQueue.main.async {
        updates()
    }
}
