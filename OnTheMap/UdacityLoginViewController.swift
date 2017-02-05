//
//  ViewController.swift
//  OnTheMap
//
//  Created by Worship Computer on 2/2/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import UIKit

class UdacityLoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var debugTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugTextLabel.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
    }

    


}

