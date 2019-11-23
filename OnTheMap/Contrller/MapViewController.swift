//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Naif on 18/11/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        getStudentLocations()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func reloadPresed(_ sender: Any) {
        viewDidLoad()
    }
    
    
    func getStudentLocations()  {
        ApiRequests.getStudentsLocations() { locations , err in
            DispatchQueue.main.async {
                guard err == nil else {
                    displayAlert.displayAlert(message: "Error in making the request", title: "Error", vc: self)
                    return
                }
                var annotations = [MKPointAnnotation] ()
                
                guard let locations = locations else {
                    displayAlert.displayAlert(message: "Error in making the request", title: "Error", vc: self)
                    return
                }
                
                for dictionary in locations {
                    
                    let lat = CLLocationDegrees(dictionary.latitude ?? 0)
                    let long = CLLocationDegrees(dictionary.longitude ?? 0)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let first = dictionary.firstName ?? ""
                    let last = dictionary.lastName ?? ""
                    let mediaURL = dictionary.mediaURL ?? ""
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                
                // When the array is complete, we add the annotations to the map.
                self.mapView.addAnnotations (annotations)
            }
        }//end getAllLocations
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:])
            }
        }
    }
    
    
    @IBAction func logoutPresed(_ sender: Any) {
        ApiRequests.logout{ (success, err) in
            DispatchQueue.main.async {
                if err != nil {
                    displayAlert.displayAlert(message: "Error in loging out!", title: "Error", vc: self)
                    return
                }
                if !success {
                    displayAlert.displayAlert(message: "Error in loging out!", title: "Error", vc: self)
                } else {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
}
