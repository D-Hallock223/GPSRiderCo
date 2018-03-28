//
//  Extensions.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 3/27/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import Foundation


extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}


func RemainingDays(date:String) -> Int? {
    let date3 = Formatter.iso8601.date(from: date)
    
    let calendar = NSCalendar.current
    
    // Replace the hour (time) of both dates with 00:00
    let date1 = calendar.startOfDay(for: Date())
    let date2 = calendar.startOfDay(for: date3!)
    
    let components = calendar.dateComponents([.day], from: date1, to: date2)
    return components.day
}
