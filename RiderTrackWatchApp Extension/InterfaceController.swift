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
    var isLoggedInFlag = false
    @IBOutlet var labelBtn: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        UserDefaults.standard.set(false, forKey: "loggedIn")
        session  = WCSession.default
        session?.delegate = self
        session?.activate()
        
        
        UserDefaults.standard.addObserver(self, forKeyPath: "loggedIn", options: .new , context: nil)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: "loggedIn")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let value = message["loggedIn"] as? Bool {
            if value{
                UserDefaults.standard.set(true, forKey: "loggedIn")
            }
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loggedIn" {
            let value = UserDefaults.standard.bool(forKey: "loggedIn")
            if value {
                isLoggedInFlag = true
                labelBtn.setTitle("Let's Go")
                labelBtn.setBackgroundColor( UIColor(red:0.72157, green:0.91373, blue:0.52549, alpha:1.00000))
            }else{
                isLoggedInFlag = false
                labelBtn.setTitle("Please sign in from iPhone to continue !")
                labelBtn.setBackgroundColor(UIColor.clear)
            }
        }
    }

    @IBAction func labelBtnTapped() {
        if isLoggedInFlag {
            pushController(withName: "StartVC", context: nil)
        } else{
            return
        }
    }
}
