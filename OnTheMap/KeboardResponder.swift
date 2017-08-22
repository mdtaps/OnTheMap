//
//  KeboardViewer.swift
//  OnTheMap
//
//  Created by Mark Tapia on 8/7/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardResponder {
    
    var keyboardReferenceElement: UIView { get }
    var keyboardGap: CGFloat { get }
    
    func adjustViewWhenKeyboardShows(_ keyboardSize: CGRect)
    func adjustViewWhenKeyboardHides()
}

extension KeyboardResponder where Self: UIViewController {
    
    var keyboardGap: CGFloat {
        get {
            let referenceElementButtomLeftCorner = CGPoint(x: keyboardReferenceElement.bounds.minX, y: keyboardReferenceElement.bounds.maxY)
            
            let submitButtonBottomLeftCornerInViewCoordinates = keyboardReferenceElement.convert(referenceElementButtomLeftCorner, to: self.view)
            
            return view.frame.maxY - submitButtonBottomLeftCornerInViewCoordinates.y
        }
    }
    
    func adjustViewWhenKeyboardShows(_ keyboardSize: CGRect) {
        if view.frame.origin.y == 0 {
            
            print(keyboardGap)
            print(keyboardSize.height)
            
            if keyboardGap < keyboardSize.height + 20 {
                print(keyboardGap, keyboardSize.height)
                self.view.frame.origin.y -= (keyboardSize.height + 20) - keyboardGap
            }
        }
    }
    
    func adjustViewWhenKeyboardHides() {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}
