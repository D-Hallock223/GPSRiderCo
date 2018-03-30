//
//  User.swift
//  RiderTrackWatchApp Extension
//
//  Created by AKIL KUMAR THOTA on 3/26/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import Foundation

class WatchUser {
    
    var username:String?
    var email:String?
    var token:String?
    var participatingEventId:String?
    
    private init() {}
    
    static let sharedInstance = WatchUser()

    
}
