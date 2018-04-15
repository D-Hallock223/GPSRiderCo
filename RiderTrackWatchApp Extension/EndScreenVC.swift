//
//  EndScreenVC.swift
//  RiderTrackWatchApp Extension
//
//  Created by AKIL KUMAR THOTA on 4/13/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import WatchKit
import Foundation

class EndScreenVC: WKInterfaceController {
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
      
       
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
        
    }

}
