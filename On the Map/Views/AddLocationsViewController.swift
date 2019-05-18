//
//  AddLocationsViewController.swift
//  On the Map
//
//  Created by Amal Alqadhibi on 15/05/2019.
//  Copyright © 2019 Amal Alqadhibi. All rights reserved.
//

import UIKit
import CoreLocation
import NotificationCenter
class AddLocationsViewController: UIViewController {
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var latitude:Double?
    var longitude:Double?
    
    @IBAction func findLocation(_ sender: Any) {
        if location.text == "" || url.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please Enter your location and URL ", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            activityIndicator.startAnimating()
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(location.text!) { (placemarks, error) in
                guard let placemarks = placemarks,let locationCoordinate = placemarks.first?.location
                    else {
                        let alertController = UIAlertController(title: "Oops!", message: "Please check your connection or enter correct city name", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        return
                }
                self.latitude = locationCoordinate.coordinate.latitude
                self.longitude = locationCoordinate.coordinate.longitude
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "ShowLocationOnMap", sender: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! MapWithPinViewController
        controller.latitude = self.latitude
        controller.longitude = self.longitude
        controller.mapString = self.location.text
        controller.url = self.url.text
    }
    // hide the keyboard when user touch the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
