//
//  MapWithPinViewController.swift
//  On the Map
//
//  Created by Amal Alqadhibi on 15/05/2019.
//  Copyright © 2019 Amal Alqadhibi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapWithPinViewController: UIViewController ,MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var latitude:Double!
    var longitude:Double!
    var url:String!
    var mapString:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        findLocations()
    }
    @IBAction func FinishPostNewlocation(){
        activityIndicator.startAnimating()
        APICalls.postStudentLocation(mapString: mapString , mediaURL: url, latitude: latitude, longitude: longitude) {(error) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
            }
            if  let error = error {
                let alertController = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            UserDefaults.standard.set(self.mapString, forKey: "Userlocation")
            DispatchQueue.main.async {
                self.parent!.dismiss(animated: true, completion: nil)
            }
        }
    }
    //Show user location to user
    func findLocations() {
        let coords = CLLocationCoordinate2D (latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        //create annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coords
        self.map.addAnnotation(annotation)
        // zoom to annotation
        let region = MKCoordinateRegion(center: coords, span: MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 0.0))
        map.setRegion(region, animated: true)
    }
}
