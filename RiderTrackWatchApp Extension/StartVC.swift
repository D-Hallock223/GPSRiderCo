//
//  StartVC.swift
//  RiderTrackWatchApp Extension
//
//  Created by AKIL KUMAR THOTA on 2/21/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import WatchKit

class StartVC: WKInterfaceController {
    
    
    @IBOutlet var startBtn: WKInterfaceButton!
    
    var showStopBtn:Bool!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        showStopBtn = false
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if showStopBtn {
           startBtn.setTitle("STOP")
        } else{
            startBtn.setTitle("START")
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    
    }
    
    @IBAction func startBtnTapped() {
        if showStopBtn {
            showStopBtn = false
            self.popToRootController()
        }else{
            showStopBtn = true
            pushController(withName: "TrackVC", context: nil)
        }
    }
    
}
