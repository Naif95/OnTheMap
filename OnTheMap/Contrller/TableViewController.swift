//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Naif on 18/11/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class TableViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var studentLocations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getStudentLocations()
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
                
                guard let locations = locations else {
                    displayAlert.displayAlert(message: "Error in making the request", title: "Error", vc: self)
                    return
                }
                self.studentLocations = locations
                self.tableView.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let info = self.studentLocations[(indexPath as NSIndexPath).row]
        cell.name.text = ("\(info.firstName ?? "") \(info.lastName ?? "")")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInfo = self.studentLocations[(indexPath as NSIndexPath).row]
        let url = URL(string: studentInfo.mediaURL ?? "?")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:])
        }else{
           displayAlert.displayAlert(message: "URL unable be opened", title: "Invalid URL", vc: self)
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
