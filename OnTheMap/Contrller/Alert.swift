//
//  Alert.swift
//  OnTheMap
//
//  Created by Naif on 18/11/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit


struct displayAlert {
    
    static func displayAlert(message: String, title: String, vc: UIViewController)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(OKAction)
        
        vc.present(alertController, animated: true, completion: nil)
    }
}
