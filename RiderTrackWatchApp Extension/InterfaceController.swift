//
//  InterfaceController.swift
//  RiderTrackWatchApp Extension
//
//  Created by AKIL KUMAR THOTA on 2/19/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController,WCSessionDelegate {
    
    var session :WCSession?
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        session  = WCSession.default
        session?.delegate = self
        session?.activate()
        
        
        UserDefaults.standard.addObserver(self, forKeyPath: "loggedIn", options: .new , context: nil)
        
        // Configure interface objects here.
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let value = message["loggedIn"] as? Bool {
            UserDefaults.standard.set(true, forKey: "loggedIn")
        }
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: "loggedIn")
    }
    
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        print("called deactivate")
        UserDefaults.standard.set(false, forKey: "loggedIn")
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loggedIn" {
            let value = UserDefaults.standard.bool(forKey: "loggedIn")
            if value {
                //do the segue
                print("doing the segue")
                
            }
        }
    }

}
