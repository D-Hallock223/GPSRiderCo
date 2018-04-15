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
    
    //last seen.
    var eventToken:String?
    
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
        var wEventID = ""
        var wStartPointLat = 0.0
        var wStartPointLon = 0.0
        var wEndPointLat = 0.0
        var wEndPointLon = 0.0
        
        if let username = message["username"] as? String {
            wUsername = username
        }
        if let email = message["email"] as? String {
            wEmail = email
        }
        if let token = message["token"] as? String {
            wToken = token
        }
        if let eventID = message["eventId"] as? String {
            wEventID = eventID
        }
        if let lat = message["startPointLat"] as? Double {
            wStartPointLat = lat
        }
        if let lon = message["startPointLon"] as? Double {
            wStartPointLon = lon
        }
        if let endLat = message["endPointLat"] as? Double {
            wEndPointLat = endLat
        }
        if let endLon = message["endPointLon"] as? Double {
            wEndPointLon = endLon
        }
        if wUsername != "" && wEmail != "" && wToken != "" && wEventID != "" && wStartPointLat != 0.0 && wStartPointLon != 0.0 && wEndPointLat != 0.0 && wEndPointLon != 0.0 {
            WatchUser.sharedInstance.username = wUsername
            WatchUser.sharedInstance.email = wEmail
            WatchUser.sharedInstance.token = wToken
            WatchUser.sharedInstance.participatingEventId = wEventID
            WatchUser.sharedInstance.eventStartPointLat = wStartPointLat
            WatchUser.sharedInstance.eventStartPointLon = wStartPointLon
            WatchUser.sharedInstance.eventEndPointLat = wEndPointLat
            WatchUser.sharedInstance.eventEndPointLon = wEndPointLon
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
                isLoggedInFlag = false
                DispatchQueue.main.async {
                    self.labelBtn.setTitle("Select an event from iPhone to continue!")
                    self.labelBtn.setBackgroundColor(UIColor.clear)
                }
            }
        }
    }

    @IBAction func labelBtnTapped() {
        if isLoggedInFlag {
            pushController(withName: "StartVC", context: session)
        } else{
            return
        }
    }
}
