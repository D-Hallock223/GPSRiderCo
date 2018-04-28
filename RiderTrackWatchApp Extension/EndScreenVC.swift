//
//  EndScreenVC.swift
//  RiderTrackWatchApp Extension
//
//  Created by AKIL KUMAR THOTA on 4/13/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class EndScreenVC: WKInterfaceController {
    
    var session:WCSession!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.session = context as! WCSession
        self.setTitle("")
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    

    
    @IBAction func closeBtnTapped() {
        sendMessagetoPhone()
        UserDefaults.standard.set(false, forKey: "loggedIn")
        self.dismiss() 
    }

    
    func sendMessagetoPhone() {
        session?.sendMessage(["close":true], replyHandler: nil, errorHandler: { (error) in
            print(error.localizedDescription)
            print("error sending message to iphone")
        })
    }
}
