//
//  ApiRequests.swift
//  OnTheMap
//
//  Created by Naif on 13/11/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation


class ApiRequests {
    
    
    class func postLogin(_ username : String!, _ password : String!, completion: @escaping (Bool, String, Error?)->()) {
        let url = URL(string: "https://onthemap-api.udacity.com/v1/session")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username!)\", \"password\": \"\(password!)\"}}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard data != nil else {
                print(err!)
                completion(false, "", err!)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let error = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (false, "", error)
                return
            }
            if statusCode >= 200  && statusCode < 300 {
                let range = (5..<data!.count)
                let newData = data?.subdata(in: range)
                print(String(data: newData!, encoding: .utf8)!)
                
                let json = try! JSONSerialization.jsonObject(with: newData!, options: []) as? [String : Any]
                let account = json? ["account"] as? [String : Any]
                let key = account? ["key"] as? String ?? " "
                completion(true, key , nil)
            } else {
                completion (false, "", nil)
            }
        }
        task.resume()
    }
    
    
    class func getStudentsLocations(completion: @escaping ([StudentLocation]?, Error?) -> ())
    {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, err in
            guard data != nil else {
                print(err!)
                completion(nil, err)
                return
            }
            let result = try! JSONDecoder().decode(Result.self, from: data!)
            completion(result.results,nil)
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func postStudentLocation (_ mapString : String!, _ mediaURL : String!,_ uniqueKey :String!, _ latitude : Double!,_ longitude : Double!,  completion: @escaping (StudentLocation?, Error?) -> ())
    {
        let url = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(uniqueKey ?? "?")\", \"firstName\": \"\("Naif")\", \"lastName\": \"\("Mu")\",\"mapString\": \"\(mapString ?? "?")\", \"mediaURL\": \"\(mediaURL ?? "?")\",\"latitude\": \(latitude ?? 0.00), \"longitude\": \(longitude ?? 0.00)}".data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard data != nil else {
                print(err!)
                completion(nil, err!)
                return
            }
            let result = try! JSONDecoder().decode(OneResult.self, from: data!)
            completion(result.singleStudint,nil)
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func logout(completion: @escaping (Bool, Error?)->()) {
        let url = URL(string: "https://onthemap-api.udacity.com/v1/session")
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard data != nil else {
                print(err!)
                completion(false, err!)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let error = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (false, error)
                return
            }
            if statusCode >= 200  && statusCode < 300 {
                completion(true, nil)
            } else {
                completion (false, nil)
            }
        }
        task.resume()
    }
}


