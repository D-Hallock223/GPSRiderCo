//
//  MapWatchVC.swift
//  RiderTrackWatchApp Extension
//
//  Created by AKIL KUMAR THOTA on 2/21/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import WatchKit

class MapWatchVC: WKInterfaceController,dataTransmission {
    
    var trackObject:TrackVC!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        trackObject = context as! TrackVC
        trackObject.delegate = self
   
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
    }
    
    func getData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        print(latitude,longitude)
    }
    
    
}
