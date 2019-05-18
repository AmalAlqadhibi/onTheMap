//
//  MapViewController.swift
//  On the Map
//
//  Created by Amal Alqadhibi on 12/05/2019.
//  Copyright © 2019 Amal Alqadhibi. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        map.delegate = self
        APICalls.getStudentLocations(completion: handleGetStudentLocationResponse(succes:studentLocations:error:))
        // Do any additional setup after loading the view.
    }
    //MARK:- Navigation bar Actions
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
                self.performSegue(withIdentifier: "ShowAddLocations", sender: self)
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
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            
        }
        guard error == nil else {return}
        if succes {
            var annotations = [MKPointAnnotation]()
            guard let studentLocations = studentLocations else {return}
            DispatchQueue.main.async {
                for studentLocation in studentLocations {
                    let latitude = studentLocation.latitude
                    let longitude = studentLocation.longitude
                    let coords = CLLocationCoordinate2D (latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coords
                    annotation.title = (studentLocation.firstName ?? "First name ") + (studentLocation.lastName ?? " Last name")
                    annotation.subtitle = studentLocation.mediaURL
                    annotations.append (annotation)
                }
                self.map.addAnnotations(annotations)
            }
            
        }
        
    }
    
}
// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.markerTintColor = UIColor.init(red: 119/255, green: 43/255, blue: 82/255 , alpha: 0.9)
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
        if control == view.rightCalloutAccessoryView {
            guard let url = URL(string:(view.annotation?.subtitle)! ?? "") else {
                let alert = UIAlertController(title: "Error", message: "Invalid URL", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return }
            UIApplication.shared.open( url , options: [:], completionHandler: nil)
        }
    }
}
