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
