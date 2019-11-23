//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Naif on 18/11/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class Result: Codable {
    var results: [StudentLocation]?
}

struct OneResult: Codable {
    var singleStudint: StudentLocation?
}


struct StudentLocation : Codable {
    
    let createdAt : String?
    let firstName : String?
    let lastName : String?
    let latitude : Double?
    let longitude : Double?
    let mapString : String?
    let mediaURL : String?
    let objectId : String?
    let uniqueKey : String?
    let updatedAt : String?
    
}
