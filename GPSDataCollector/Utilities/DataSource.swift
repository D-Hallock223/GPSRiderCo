//
//  DataSource.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 3/26/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataSource {
    
    private init () {}
    
    static let sharedInstance = DataSource()
    
    func getAllEvents(Completion:@escaping ([Event]?) -> ()){
        
        guard let eventURL = URL(string: URL_GET_ALL_EVENTS) else {
            Completion(nil)
            return}
        Alamofire.request(eventURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.result.error != nil {
                Completion(nil)
                return
            }
            if response.result.isSuccess {
                var events = [Event]()
                let json = try! JSON(data: response.data!)
                let eventsArray = json.arrayValue
                for event in eventsArray {
                    let DraceWinners = event["raceWinners"].arrayObject
                    let Did = event["_id"].stringValue
                    let Dname = event["name"].stringValue
                    let DeventImgLink = event["image"].stringValue
                    let Ddescription = event["description"].stringValue
                    let Ddate = event["date"].stringValue
                    let Dlocation = event["location"].stringValue
                    let DeventTimeRange = event["time"].stringValue
                    
                    let eventObj = Event(raceWinners: DraceWinners as? [String], id: Did, name: Dname, eventImgLink: DeventImgLink, eventDescription: Ddescription, date: Ddate, location: Dlocation, eventTimeRange: DeventTimeRange)
                    events.append(eventObj)
                }
                Completion(events)
            }else{
                Completion(nil)
                return
            }
        }
   
    }
    
    
    func registerForanEvent(eventId:String,token:String,completion:@escaping(Bool,Bool)->()) {
        guard let sendURL = URL(string: URL_PREPOD_REGISTER_FOR_EVENT) else {return}
        let parameters:[String:Any] = ["eventid": eventId]
        let headers = ["Content-Type":"application/json",
                       "Authorization":"Bearer \(token)"
                       ]
        Alamofire.request(sendURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error != nil {
                print("error occured during registerForanEvent request")
                completion(false,false)
                return
            }
            if response.result.isSuccess {
                let json = try! JSON(data: response.data!)
                let value = json["result"].stringValue
                if value == "newRegistration" {
                    completion(true,true)
                }else if value == "alreadyRegistered"{
                    completion(true,false)
                }else{
                    print("spelling error occured")
                    completion(false,false)
                }
            } else {
                print("error occured during registerForanEvent request")
                completion(false,false)
            }
        }
    }
    
    func getEventsRegisteredForCurrentUser(token:String,completion:@escaping([String]?)->()) {
        guard let sendURL = URL(string: URL_PREPOD_GET_REGISTERED_EVENTS) else {
            completion(nil)
            return}
        let headers = ["Content-Type":"application/json",
                       "Authorization":"Bearer \(token)"
        ]
        Alamofire.request(sendURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error != nil {
                print("error occured during getting registered Events request")
                completion(nil)
                return
            }
            if response.result.isSuccess {
                let json = try! JSON(data: response.data!)
                let eventsArray = json["registeredEvents"].arrayValue
                var res = [String]()
                for event in eventsArray {
                    let id = event["_id"].stringValue
                    res.append(id)
                }
                completion(res)
            }else{
                print("error occured during getting registered Events request")
                completion(nil)
                return
            }
        }
        
    } 
}
