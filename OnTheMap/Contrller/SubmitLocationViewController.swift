//
//  SubmitLocationViewController.swift
//  OnTheMap
//
//  Created by Naif on 20/11/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class SubmitLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        makeAnnotation()
    }
    
    var mapString:String?
    var mediaURL:String?
    var latitude:Double?
    var longitude:Double?
    var uniqueKey:String?
    
    func makeAnnotation()
    {
        let annotation = MKPointAnnotation()
        annotation.title = mapString!
        annotation.subtitle = mediaURL!
        annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        mapView.addAnnotation(annotation)
        
        //zooming to location
        let coredinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coredinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    @IBAction func SubmitPrsed(_ sender: Any) {
        ApiRequests.postStudentLocation(mapString, mediaURL, uniqueKey, latitude, longitude) { (studentsLocation, error) in
            DispatchQueue.main.async {
                
                if error != nil {
                    displayAlert.displayAlert(message: "Error in submting the request", title: "Error", vc: self)
                    return
                }
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }

}
