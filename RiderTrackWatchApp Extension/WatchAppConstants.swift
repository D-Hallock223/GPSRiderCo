//
//  WatchAppConstants.swift
//  RiderTrackWatchApp Extension
//
//  Created by AKIL KUMAR THOTA on 2/19/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import Foundation

extension Double
{
    func truncate(_ places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}


