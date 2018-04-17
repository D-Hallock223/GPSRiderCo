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

        Alamofire.request(eventURL).responseJSON { (response) in
            
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
                    let DstartTime = event["startTime"].stringValue
                    let DendTime = event["endTime"].stringValue
                    let Dlength = event["track"]["length"].intValue
                    let Ddifficulty = event["track"]["difficulty"].stringValue
                    var diffValue:Int!
                    if Ddifficulty == "Beginner" {
                        diffValue = 0
                    } else if Ddifficulty == "Hard" {
                        diffValue = 2
                    } else {
                        diffValue = 1
                    }
                    let DlatValue = event["startLocation"]["lat"].doubleValue
                    let DlongValue = event["startLocation"]["long"].doubleValue
                    
                    let DendLatValue = event["endLocation"]["lat"].doubleValue
                    let DendLonValue = event["endLocation"]["long"].doubleValue
                    
                    let DTrackFileLink = event["trackFile"].stringValue
                    
                    let eventObj = Event(length: Dlength, trackCoordinateLat: DlatValue, trackCoordinateLong: DlongValue, endvalueLat: DendLatValue, endvalueLon: DendLonValue, difficulty: diffValue, raceWinners: DraceWinners as? [String], id: Did, name: Dname, eventImgLink: DeventImgLink, eventDescription: Ddescription, date: Ddate, location: Dlocation,startTime: DstartTime, endTime: DendTime, trackFileLink: DTrackFileLink)
                    
                    events.append(eventObj)
                }
                Completion(events)
            }else{
                Completion(nil)
                return
            }
        }
   
    }
    
    
    func registerForanEvent(eventId:String,token:String,completion:@escaping(Bool)->()) {
        guard let sendURL = URL(string: URL_REGISTER_FOR_EVENT) else {return}
        let parameters:[String:Any] = ["eventId": eventId]
        let headers = ["Content-Type":"application/x-www-form-urlencoded",
                       "Authorization":"Bearer \(token)"
                       ]
        Alamofire.request(sendURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error != nil {
                print("error occured during registerForanEvent request")
                completion(false)
                return
            }
            if response.result.isSuccess {
                let json = try! JSON(data: response.data!)
                let value = json["Result"].boolValue
                if value == true{
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                print("error occured during registerForanEvent request")
                completion(false)
            }
        }
    }
    
    func getEventsRegisteredForCurrentUser(token:String,completion:@escaping([Event]?)->()) {
        guard let sendURL = URL(string: URL_GET_REGISTERED_EVENTS) else {
            completion(nil)
            return}
        let headers = [
                       "Authorization":"Bearer \(token)"
        ]
        
        Alamofire.request(sendURL, method: .get,headers: headers).responseJSON { (response) in
            if response.result.error != nil {
                print("error occured during getting registered Events request")
                completion(nil)
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
                    let DstartTime = event["startTime"].stringValue
                    let DendTime = event["endTime"].stringValue
                    let Dlength = event["track"]["length"].intValue
                    let Ddifficulty = event["track"]["difficulty"].stringValue
                    var diffValue:Int!
                    if Ddifficulty == "Beginner" {
                        diffValue = 0
                    } else if Ddifficulty == "Hard" {
                        diffValue = 2
                    } else {
                        diffValue = 1
                    }
                    let DlatValue = event["startLocation"]["lat"].doubleValue
                    let DlongValue = event["startLocation"]["long"].doubleValue
                    let DendLatValue = event["endLocation"]["lat"].doubleValue
                    let DendLonValue = event["endLocation"]["long"].doubleValue
                    
                    let DTrackFileLink = event["trackFile"].stringValue
                    
                    let eventObj = Event(length: Dlength, trackCoordinateLat: DlatValue, trackCoordinateLong: DlongValue, endvalueLat: DendLatValue, endvalueLon: DendLonValue, difficulty: diffValue, raceWinners: DraceWinners as? [String], id: Did, name: Dname, eventImgLink: DeventImgLink, eventDescription: Ddescription, date: Ddate, location: Dlocation,startTime: DstartTime, endTime: DendTime, trackFileLink: DTrackFileLink)
                    
                    events.append(eventObj)
                }
                completion(events)

            }else{
                print("error occured during getting registered Events request")
                completion(nil)
                return
            }
        }
        
    }
    
    func unregisterForTheEvent(eventId:String,token:String,completion:@escaping(Bool)->()) {
        
        guard let sendURL = URL(string: URL_UNREGISTER_EVENT) else {return}
        let parameters:[String:Any] = ["eventId": eventId]
        let headers = ["Content-Type":"application/x-www-form-urlencoded",
                       "Authorization":"Bearer \(token)"
        ]
        Alamofire.request(sendURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error != nil {
                print("error occured during registerForanEvent request")
                completion(false)
                return
            }
            if response.result.isSuccess {
                let json = try! JSON(data: response.data!)
                let value = json["Result"].boolValue
                if value == true {
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                print("error occured during registerForanEvent request")
                completion(false)
            }
        }
        
    }
    
    
    
}
