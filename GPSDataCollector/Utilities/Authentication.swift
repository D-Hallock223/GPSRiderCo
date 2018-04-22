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
    
    
    func signInuser(userName:String,email:String,password:String,completion: @escaping (Bool,String?) -> ()){
        
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
                let resultToken = json["user"]["token"].stringValue
                completion(true,resultToken)
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
                let result = json["result"].bool
                if let res = result {
                    if res == false {
                        completion(false,nil)
                        return
                    }
                }
                let user = json["user"].dictionaryValue
                let DuserName = user["username"]!.stringValue
                let Demail = user["email"]!.stringValue
                let DfirstName = user["firstName"]!.stringValue
                let DlastName = user["lastName"]!.stringValue
                let Dheight = user["height"]!.doubleValue
                let Dweight = user["weight"]!.doubleValue
                let Dgender = user["gender"]!.stringValue
                let Dbio = user["bio"]!.stringValue
                let DphoneNum = user["phoneNo"]!.stringValue
                let Daddress = user["address"]!.stringValue
                let Dimage = user["image"]!.stringValue
                let Dtoken = user["token"]!.stringValue
                
                let newUser = User(username: DuserName, email: Demail, firstName: DfirstName, lastName: DlastName, height: Dheight, weight: Dweight, gender: Dgender, bio:Dbio, phoneNum: DphoneNum, address: Daddress, profileImage: Dimage, token: Dtoken)
                
                completion(true,newUser)
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
    
    
    func updateUserInformation(token:String,parameters:[String:Any],completion:@escaping (Bool,User?)->()) {
        
        guard let sendUrl = URL(string: URL_UPDATE_USER) else {
            completion(false,nil)
            return}
        
        let headers = ["Content-Type":"application/x-www-form-urlencoded",
                       "Authorization":"Bearer \(token)"
        ]
        Alamofire.request(sendUrl, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess {
                let json = try! JSON(data: response.data!)
                let user = json["user"].dictionaryValue
                let DuserName = user["username"]!.stringValue
                let Demail = user["email"]!.stringValue
                let DfirstName = user["firstName"]!.stringValue
                let DlastName = user["lastName"]!.stringValue
                let Dheight = user["height"]!.doubleValue
                let Dweight = user["weight"]!.doubleValue
                let Dgender = user["gender"]!.stringValue
                let Dbio = user["bio"]!.stringValue
                let DphoneNum = user["phoneNo"]!.stringValue
                let Daddress = user["address"]!.stringValue
                let Dimage = user["image"]!.stringValue
                let Dtoken = user["token"]!.stringValue
                
                let newUser = User(username: DuserName, email: Demail, firstName: DfirstName, lastName: DlastName, height: Dheight, weight: Dweight, gender: Dgender, bio:Dbio, phoneNum: DphoneNum, address: Daddress, profileImage: Dimage, token: Dtoken)
                
                completion(true,newUser)
                
            } else {
                completion(false,nil)
                return
            }
        }
        
        
    }
    
    
    
    
    
}
