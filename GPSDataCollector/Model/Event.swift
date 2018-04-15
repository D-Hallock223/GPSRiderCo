//
//  Event.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 3/26/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import Foundation


struct Event {
    
    let length:Int
    let trackCoordinateLat:Double
    let trackCoordinateLong:Double
    let endvalueLat:Double
    let endvalueLon:Double
    let difficulty:Int
    var raceWinners:[String]?
    let id:String
    let name:String
    var eventImgLink:String
    let eventDescription:String
    let date:String
    let location:String
    let startTime:String
    let endTime:String
    
}
