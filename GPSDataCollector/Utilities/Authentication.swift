//
//  Authentication.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 3/12/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class Authentication {
    
    
    private init() {}
    
    static let sharedInstance = Authentication()
    
    
    func signInuser(userName:String,email:String,password:String,completion: @escaping (Bool,User?) -> ()){
        
        guard let url = URL(string: URL_SING_IN) else {
            completion(false,nil)
            return }
        
        let parameters:[String:Any] = ["username": userName,
                                       "email":  email,
                                       "password":  password]
        let headers = ["Content-Type":"application/x-www-form-urlencoded"]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                let json = try! JSON(data: response.data!)
                let resultUsername = json["user"]["username"].stringValue
                let resultEmail = json["user"]["email"].stringValue
                let resultToken = json["user"]["token"].stringValue
                let userObj = User(username: resultUsername, email: resultEmail, token: resultToken)
                completion(true,userObj)
            } else {
                completion(false,nil)
            }
        }
        
    }
    
    
    func logInUser(email:String,password:String,completion: @escaping (Bool,User?)-> ()) {
        
        
        guard let url = URL(string: URL_LOG_IN) else {
            completion(false,nil)
            return }
        
        let parameters:[String:Any] = ["email":  email,
                                       "password":  password]
        let headers = ["Content-Type":"application/x-www-form-urlencoded"]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                let json = try! JSON(data: response.data!)
                let resultUsername = json["user"]["username"].stringValue
                let resultEmail = json["user"]["email"].stringValue
                let resultToken = json["user"]["token"].stringValue
                if resultToken == "" {
                    completion(false,nil)
                    return
                }
                let userObj = User(username: resultUsername, email: resultEmail, token: resultToken)
                
                completion(true,userObj)
            } else {
                completion(false,nil)
            }
        }
    }
    
    
    func forgotPassword(email:String,completion:@escaping (Bool)->()) {
        guard let fpURL = URL(string: URL_FORGOT_PASSWORD) else {
            completion(false)
            return
        }
        let parameters:[String:Any] = ["email":  email]
        let headers = ["Content-Type":"application/x-www-form-urlencoded"]
        Alamofire.request(fpURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                let json = try! JSON(data: response.data!)
                print(json)
                let result = json["result"].boolValue
                if result == true {
                    completion(true)
                    return
                }
                completion(false)
            } else {
                completion(false)
            }
        }
    }
    
    
    
    
    
}
