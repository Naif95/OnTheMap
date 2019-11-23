//
//  AddingNewLocationViewController.swift
//  OnTheMap
//
//  Created by Naif on 20/11/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class AddingNewLocationViewController: UIViewController, UITextFieldDelegate {
    
    var latitude : Double?
    var longitude : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
        enterdLocation.delegate = self
        enterdWebsite.delegate = self
    }
    
    @IBOutlet weak var enterdLocation: UITextField!
    @IBOutlet weak var enterdWebsite: UITextField!
    
    @IBAction func cancelPresed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationPresed(_ sender: Any) {
        
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = enterdLocation.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            if error != nil {
                displayAlert.displayAlert(message: "Error in making the request", title: "Error", vc: self)
            }
            self.latitude = response?.boundingRegion.center.latitude
            self.longitude = response?.boundingRegion.center.longitude
            self.performSegue(withIdentifier: "go to submit", sender: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go to submit"{
            let vc = segue.destination as! SubmitLocationViewController
            vc.latitude = self.latitude
            vc.longitude = self.longitude
            vc.mapString = enterdLocation.text
            vc.mediaURL = enterdWebsite.text
            vc.uniqueKey = LoginController.key
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if enterdWebsite.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)/2
        }
        if enterdLocation.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)/2
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    @objc func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
