//
//  LoginController.swift
//  OnTheMap
//
//  Created by Naif on 12/11/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    
    static var key : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToKeyboardNotifications()
        username.delegate = self
        password.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func LoginPressed(_ sender: Any) {
        
        guard let username = username.text else {return}
        guard let password = password.text else {return}
        
        if (username.isEmpty) || (password.isEmpty) {
            displayAlert.displayAlert(message: "Email or password is empty", title: "Erorr", vc: self)
        }
        
        ApiRequests.postLogin(username, password) {(loginSuccess, key, error) in
            DispatchQueue.main.async {
                //print the error
                if error != nil  {
                    displayAlert.displayAlert(message: "Error in making the request", title: "Error", vc: self)
                    return
                    
                }
                if !loginSuccess {
                    displayAlert.displayAlert(message: "Email or password is incorrect, try again", title: "Erorr", vc: self)
                    return
                }
                LoginController.key = key
                print(key)
                self.performSegue(withIdentifier: "klm", sender: nil)
            }
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
        if username.isFirstResponder {
              view.frame.origin.y = -getKeyboardHeight(notification)/2
          }
          if password.isFirstResponder {
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
          return true;
      }
      
}
