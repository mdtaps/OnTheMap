//
//  TableTableViewController.swift
//  OnTheMap
//
//  Created by Lindsey Renee Eaton on 2/26/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import UIKit

class UsersTableViewController: PinViewController {
    
    @IBOutlet var usersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersTableView.delegate = self
        usersTableView.dataSource = self
    }
    
}

extension UsersTableViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return StudentPins.sharedInstance.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseId = "studentCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? UserTableViewCellController else {
            
            print("Cell dequeue failed")
            return UITableViewCell()
        }
        
        let student = StudentPins.sharedInstance[indexPath.row]
        
        let firstName = student.firstName
        let lastName = student.lastName
        
        cell.userNameLabel.text = firstName + " " + lastName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = StudentPins.sharedInstance[indexPath.row]
        
        guard let url = URL(string: student.mediaUrl) else {
            print("URL creation failed")
            return
        }
        
        let app = UIApplication.shared
        
        app.open(url, options: [:], completionHandler: nil)
    }
}
