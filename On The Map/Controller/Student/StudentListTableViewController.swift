//
//  StudentListTableViewController.swift
//  On The Map
//
//  Created by Javon Davis on 23/06/2017.
//  Copyright © 2017 Javon Davis. All rights reserved.
//

import UIKit
import FacebookLogin

class StudentListTableViewController: UITableViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var loadingIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadingIndicator()
        loadingIndicator.stopAnimating()
        refresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let newLocation = appDelegate.newLocation { // Add a new location for a Student
            confirmNewLocation(location: newLocation)
            appDelegate.newLocation = nil
            refresh()
        }
    }
    
    func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        loadingIndicator.activityIndicatorViewStyle = .whiteLarge
        loadingIndicator.color = .blue
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
        self.view.addSubview(loadingIndicator)
    }
    
    func saveToParse(location: StudentLocation) {
        ParseClient.shared.postStudentLocation(studentLocation: location, updating: locationExistsForCurrentUser(), completion: { error in
            if let error = error {
                print(error.localizedDescription)
                self.showAlert(title: "Oops!", message: "There was an error saving your location to the database")
                self.refresh()
                return
            }
            self.appDelegate.userLocation = location
        })
    }
    
    func confirm(studentLocation: StudentLocation) {
        var message = "Do you want to save this location"
        var location = studentLocation // StudentLocation is a struct
        
        if locationExistsForCurrentUser() {
            message = "Do you want to Overwrite your existing location at \(appDelegate.userLocation!.mapString!)?"
            
            location.objectId = appDelegate.userLocation?.objectId!
        }
        
        let alertController = UIAlertController(title: "Confirm Location", message: message, preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.saveToParse(location: location)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
            self.appDelegate.studentLocations.removeFirst()
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func confirmNewLocation(location: StudentLocation) {
        appDelegate.studentLocations.insert(location, at: 0)
        refresh()
        confirm(studentLocation: location)
    }
    
    // MARK:- IBActions
    
    @IBAction func refresh() {
        loadingIndicator.startAnimating()
        loadStudentLocations(completion:{
            self.tableView.reloadData()
            self.loadingIndicator.stopAnimating()
        })
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "showStudentInformation", sender: self)
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        loadingIndicator.startAnimating()
        UdacityClient.shared.endSession(completion: { sessionId, userId, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print(sessionId!)
            }
            performUIUpdatesOnMain {
                self.loadingIndicator.stopAnimating()
                self.performSegue(withIdentifier: "showLogin", sender: self)
            }
        })
        
        LoginManager().logOut()
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
