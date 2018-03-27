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
    
    
    @IBOutlet var labelBtn: WKInterfaceButton!
    
    
    var session :WCSession?
    var isLoggedInFlag = false
    
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
            }else{
                UserDefaults.standard.set(false, forKey: "loggedIn")
            }
        }
        
        var wUsername = ""
        var wEmail = ""
        var wToken = ""
        
        if let username = message["username"] as? String {
            wUsername = username
        }
        if let email = message["email"] as? String {
            wEmail = email
        }
        if let token = message["token"] as? String {
            wToken = token
        }
        if wUsername != "" && wEmail != "" && wToken != "" {
            WatchUser.sharedInstance.username = wUsername
            WatchUser.sharedInstance.email = wEmail
            WatchUser.sharedInstance.token = wToken
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loggedIn" {
            let value = UserDefaults.standard.bool(forKey: "loggedIn")
            if value {
                isLoggedInFlag = true
                DispatchQueue.main.async {
                    self.labelBtn.setTitle("Let's Go")
                    self.labelBtn.setBackgroundColor( UIColor(red:0.72157, green:0.91373, blue:0.52549, alpha:1.00000))
                }
            }else{
                DispatchQueue.main.async {
                    self.popToRootController()
                }
                WatchUser.sharedInstance.username = nil
                WatchUser.sharedInstance.email = nil
                WatchUser.sharedInstance.token = nil
                isLoggedInFlag = false
                DispatchQueue.main.async {
                    self.labelBtn.setTitle("Please sign in from iPhone to continue !")
                    self.labelBtn.setBackgroundColor(UIColor.clear)
                }
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
