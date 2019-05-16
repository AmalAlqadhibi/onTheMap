//
//  ListOfStudentslocationsTableViewController.swift
//  On the Map
//
//  Created by Amal Alqadhibi on 14/05/2019.
//  Copyright © 2019 Amal Alqadhibi. All rights reserved.
//

import UIKit
import Foundation

class ListOfStudentslocationsTableViewController: UITableViewController {
    var studentsLocations: [StudentsLocations]! {
        return Global.studentsLocations
    }
    override func viewWillAppear(_ animated: Bool) {
        if studentsLocations == nil {
            APICalls.getStudentLocations(completion: handleGetStudentLocationResponse(succes:studentLocations:error:))
        }
    }
    
    @IBAction func refreshMapAnnotation(_ sender: Any) {
        APICalls.getStudentLocations(completion: handleGetStudentLocationResponse(succes:studentLocations:error:))
    }
    @IBAction func postAnnotation(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "Userlocation") == nil {
            performSegue(withIdentifier: "ShowAddLocations", sender: self)
        } else {
            let alert = UIAlertController(title: "You have already posted a student location. Would you like to Overwrite your current location?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Overwrite", style: .destructive, handler: { (action) in
                self.performSegue(withIdentifier: "AddLocation", sender: self)
            }))
            present(alert, animated: true, completion: nil)
            
        }
    }
    @IBAction func logout(_ sender: UIBarButtonItem) {
        APICalls.deleteSession { (error) in
            if let error = error {
                let alertController = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    //MARK:- Response handler
    func handleGetStudentLocationResponse(succes:Bool,studentLocations:[StudentsLocations]? ,error: Error?) {
        print(error)
        guard error == nil else {
            let alert = UIAlertController(title: "Error", message: error?.localizedDescription , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return }
        guard studentLocations == nil else {
            let alert = UIAlertController(title: "Error", message: "Try Again!" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return studentsLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! LocationsTableViewCell
        cell.StudentName.text = (studentsLocations[indexPath.row].firstName ?? "first Name") + (studentsLocations[indexPath.row].lastName ?? "last Name")
        cell.studentURL.text = studentsLocations[indexPath.row].mediaURL ?? ""
        cell.studentURL.textColor = .gray
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string:(studentsLocations[indexPath.row].mediaURL)!) else {
            let alert = UIAlertController(title: "Error", message: "Invalid URL", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return }
        UIApplication.shared.open( url , options: [:], completionHandler: nil)
    }
}
