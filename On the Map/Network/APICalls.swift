//
//  APICalls.swift
//  On the Map
//
//  Created by Amal Alqadhibi on 13/05/2019.
//  Copyright © 2019 Amal Alqadhibi. All rights reserved.
//

import Foundation
class APICalls{
    
    class func login(username : String!, password : String!, completion: @escaping (Bool, String, Error?)->()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username!)\", \"password\": \"\(password!)\"}}".data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            // MARK:- checking error or failure
            guard  error == nil else {
                completion (false, "", error)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (false, "", statusCodeError)
                return
            }
            guard statusCode >= 200  && statusCode < 300 else {
                completion(false ,"", nil)
                return
            }
            guard let data = data else {
                completion(false ,"", nil)
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let jsonObject = try! JSONSerialization.jsonObject(with: newData, options: [])
            let loginDic = jsonObject as? [String:Any]
            let accountDic = loginDic? ["account"] as? [String : Any]
            let sessionID = accountDic? ["key"] as? String ?? ""
            completion(true , sessionID, nil)
            UserDefaults.standard.set(sessionID, forKey: "uniqueKey")
            }.resume()
    }
    class func getStudentLocations(completion: @escaping (Bool,[StudentsLocations]?, Error?)->()){
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // MARK:- checking error or failure
            guard  error == nil else {
                completion(false,[], error)
                return
            }
            guard let data = data else {
                completion(false,[], error)
                return
            }
            
            do {
                let jsonDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                let results = jsonDictionary["results"] as? [[String:Any]]
                let JSONObject = try! JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                let resultsData = try JSONDecoder().decode([StudentsLocations].self, from: JSONObject)
                Global.studentsLocations = resultsData  
                completion(true, resultsData , nil)
            } catch {
                completion(false,[], error)
            }
            
            }.resume()
    }
    func deleteSession(completion: @escaping (Error?) -> ()) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            completion(nil)
            }.resume()
    }
    class func getStudentInfo(completion: @escaping (Error?) -> ()){
        let urlWhere = "{\"uniqueKey\":\"\(Global.uniqueKey!)\"}"
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where="
        let url = URL(string: urlString + urlWhere.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)
        var request = URLRequest(url: url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard  error == nil else {
                completion(error)
                return }
            guard let data = data else {
                completion(error)
                return }
            do {
                let jsonDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                let results = jsonDictionary["results"] as? [[String:Any]]
                let JSONObject = try! JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                print(String(data: JSONObject, encoding: .utf8)!)
                let resultsData = try JSONDecoder().decode(StudentsLocations.self, from: JSONObject)
                completion(nil)
                UserDefaults.standard.set(resultsData.firstName, forKey: "FirstName")
                UserDefaults.standard.set(resultsData.lastName, forKey: "LastName")
                UserDefaults.standard.set(resultsData.mapString, forKey: "Userlocation")
            } catch {
                completion(error)
            }
            print(String(data: data, encoding: .utf8)!)
            }.resume()
        
    }
    class func postStudentLocation(mapString: String, mediaURL: String,latitude:Double,longitude:Double, completion: @escaping (Error?)->()){
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let firstName = UserDefaults.standard.string(forKey: "FirstName") ?? "first name"
        let LastName = UserDefaults.standard.string(forKey: "LastName") ?? "last name"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(LastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        print(String(data: request.httpBody!, encoding: .utf8)!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(error)
                return
            }
            }.resume()
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard  error == nil else {
                completion(error)
                return }
            guard let data = data else { return }
            completion(nil)
            print(String(data: data, encoding: .utf8)!)
            }.resume()
    }
}
