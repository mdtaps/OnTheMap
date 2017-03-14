//
//  TableTableViewController.swift
//  OnTheMap
//
//  Created by Lindsey Renee Eaton on 2/26/17.
//  Copyright © 2017 Mark Tapia. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    @IBOutlet var usersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ParseClient.shared.studentPins.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseId = "studentCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? UserTableViewCellController else {
            
            print("Cell dequeue failed")
            return UITableViewCell()
        }
        
        let student = ParseClient.shared.studentPins[indexPath.row]
        
        let firstName = student.firstName
        let lastName = student.lastName
        
        cell.userNameLabel.text = firstName + " " + lastName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = ParseClient.shared.studentPins[indexPath.row]
        
        guard let url = URL(string: student.mediaUrl) else {
            print("URL creation failed")
            return
        }
        
        let app = UIApplication.shared
        
        app.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func refreshPins(_ sender: UIBarButtonItem) {
        
        UdacityClient.shared.populatePersonalData { (success, error) in
            if let error = error {
                print(error)
            } else if success {
                self.usersTableView.reloadData()
            }
        }

    }
}
