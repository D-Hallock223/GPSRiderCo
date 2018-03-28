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
    
    
    
    
    
    
}
