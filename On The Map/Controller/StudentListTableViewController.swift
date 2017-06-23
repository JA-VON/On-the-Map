//
//  StudentListTableViewController.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit

class StudentListTableViewController: UITableViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func refresh() {
        loadStudentLocations(completion: self.tableView.reloadData)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        UdacityClient.shared.endSession(completion: { sessionId, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(sessionId!)
            }
            performUIUpdatesOnMain {
                self.performSegue(withIdentifier: "showLogin", sender: self)
            }
        })
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "showStudentInformation", sender: self)
    }
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        refresh()
    }
}

// MARK:- TableView DataSource
extension StudentListTableViewController { // Datasource Functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.studentLocations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableViewCellIdentifiers.studentList, for: indexPath)
        
        let studentLocation = appDelegate.studentLocations[indexPath.row]
        cell.textLabel?.text = "\(studentLocation.firstName!) \(studentLocation.lastName!)"
        
        return cell
    }
}

// MARK:- TableView Delegate
extension StudentListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = appDelegate.studentLocations[indexPath.row]
        let app = UIApplication.shared
        
        if let toOpen = studentLocation.mediaURL {
            app.open(URL(string: toOpen)!)
        }
    }
}
