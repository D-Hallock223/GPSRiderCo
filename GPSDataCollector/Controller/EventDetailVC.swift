//
//  EventDetailVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 3/27/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import SDWebImage
import WatchConnectivity
import KRProgressHUD
import MarqueeLabel


class EventDetailVC: UIViewController,UIScrollViewDelegate,WCSessionDelegate {
    
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var myPageIndicator: UIPageControl!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var raceWinnersLbl: UILabel!
    @IBOutlet weak var titleTextLbl: UILabel!
    
    @IBOutlet weak var myMarqueeLbl: MarqueeLabel!
    
    //MARK:- Properties
    
    var event:Event!
    var isPast:Bool!
    var isRegistered:Bool!
    
    
    var user:User!
    
    var session:WCSession?
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myScrollView.delegate = self
        myScrollView.contentSize = CGSize(width: (UIScreen.main.bounds.width) * 3, height: 290)
        myMarqueeLbl.isHidden = true
        setupEventData()
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session?.delegate = nil
    }
    
    // watch session code
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
    
    //MARK:- Functions
    //TODO:- get events registered by user
    func setupEventData() {
        titleTextLbl.text = event.name
        guard let imgURL = URL(string: event.eventImgLink) else {return}
        //        eventImageView.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [.continueInBackground,.scaleDownLargeImages], completed: nil)
        eventImageView.sd_setShowActivityIndicatorView(true)
        eventImageView.sd_setIndicatorStyle(.gray)
        eventImageView.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [.avoidAutoSetImage,.continueInBackground,.scaleDownLargeImages], completed: { (image, error, cache, url) in
            
            UIView.transition(with: self.view, duration: 1.35, options: .transitionCrossDissolve, animations: {
                self.eventImageView.image = image
            }, completion: nil)
        })
        if isPast {
            registerBtn.setTitle("Cannot register now!", for: .normal)
            registerBtn.isEnabled = false
            registerBtn.backgroundColor = UIColor(red:0.39216, green:0.39216, blue:0.39216, alpha:1.00000)
            var num = 1
            var res = ""
            if let winners = event.raceWinners,winners.count > 0 {
                for winner in winners{
                    res.append("\(num). \(winner)")
                    res.append("\n")
                    num += 1
                }
            }
            if res != "" {
                raceWinnersLbl.text = res
            }
        } else {
            if isRegistered {
                if raceStartCheck() {
                    registerBtn.setTitle("Let's Go", for: .normal)
                    registerBtn.isEnabled = true
                    myMarqueeLbl.isHidden = true
                }else{
                    registerBtn.setTitle("Unregister", for: .normal)
                    registerBtn.isEnabled = true
                    registerBtn.backgroundColor = UIColor(red:0.69412, green:0.23137, blue:0.23922, alpha:1.00000)
                    myMarqueeLbl.isHidden = false
                    
                }
            }
        }
        
        locationLbl.text = event.location
        let normalDate = Formatter.iso8601.date(from: event.date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: normalDate!)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        dateLbl.text = myStringafd
        timeLbl.text = getTimeRange(event: event)
        descriptionLbl.text = event.eventDescription
    }
    
    func getTimeRange(event:Event) -> String {
        let startDate = Formatter.iso8601.date(from: event.startTime)
        let endDate = Formatter.iso8601.date(from: event.endTime)
        let calendar = Calendar.current
        var startHour = calendar.component(.hour, from: startDate!)
        var endHour = calendar.component(.hour, from: endDate!)
        var startSym = "AM"
        var endSym = "AM"
        if startHour >= 12 {
            startSym = startHour == 24 ? "AM" : "PM"
            startHour = startHour > 12 ? (startHour % 12) : startHour
        }
        if endHour >= 12 {
            endSym = endHour == 24 ? "AM" : "PM"
            endHour = endHour > 12 ? (endHour % 12) : endHour
        }
        return "\(startHour)\(startSym) - \(endHour)\(endSym)"
    }
    
    
    func raceStartCheck() -> Bool {
        let num = arc4random_uniform(2)
        if num == 1 {
            return true
        }
        return false
        //        let startTime = Formatter.iso8601.date(from: event.startTime)
        //        let endTime = Formatter.iso8601.date(from: event.endTime)
        //        let date = Date()
        //        let calendar = Calendar.current
        //        let Chour = calendar.component(.hour, from: date)
        //        let Shour = calendar.component(.hour, from: startTime!)
        //        let Ehour = calendar.component(.hour, from: endTime!)
        //
        //        if Shour <= Chour && Chour <= Ehour {
        //            return true
        //        }
        //
        //        return false
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = myScrollView.contentOffset.x / myScrollView.frame.width
        if page == 0.0 || page == 1.0 || page == 2.0 {
            myPageIndicator.currentPage = Int(page)
        }
    }
    
    func displayAlert(title:String,Message:String) {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func sendMessageToWatch() {
        self.session!.sendMessage(["loggedIn":true,
                                   "username":user.username,
                                   "email":user.email,
                                   "token":user.token,
                                   "eventId":event.id,
                                   "startPointLat":event.trackCoordinateLat,
                                   "startPointLon":event.trackCoordinateLong,
                                   "endPointLat":event.endvalueLat,
                                   "endPointLon":event.endvalueLon], replyHandler: nil, errorHandler: { (error) in
                                    print("watch connectivity error occured")
        })
    }
    
    
    func unregisterEvent(){
        KRProgressHUD.show()
        DataSource.sharedInstance.unregisterForTheEvent(eventId: event.id, token: user.token) { (success) in
            KRProgressHUD.dismiss()
            if success {
                self.displayAlert(title: "Success", Message: "You have successfully unregistered for the event")
                self.registerBtn.setTitle("Register", for: .normal)
                self.registerBtn.backgroundColor = UIColor(red:0.57255, green:0.77647, blue:0.44706, alpha:1.00000)
                self.myMarqueeLbl.isHidden = true
            } else {
                self.displayAlert(title: "Failure", Message: "Failed to unregister for the event")
            }
        }
    }
    
    
    
    //MARK:- IBActions
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        if registerBtn.isEnabled == false {
            return
        }
        
        if registerBtn.titleLabel?.text == "Unregister" {
            unregisterEvent()
            return
        }
        
        if registerBtn.titleLabel?.text == "Let's Go" {
            self.sendMessageToWatch()
            let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeVC
            vc.user = self.user
            vc.session = self.session
            vc.selectedEvent = self.event
            self.present(vc, animated: true, completion: nil)
            return
        }
        KRProgressHUD.show()
        DataSource.sharedInstance.registerForanEvent(eventId: event.id, token: user.token) { (Success) in
            KRProgressHUD.dismiss()
            if Success {
                self.displayAlert(title: "Registration Successfull!", Message: "You have successfully enrolled in the event")
                if self.raceStartCheck() {
                    self.registerBtn.setTitle("Let's Go", for: .normal)
                    self.myMarqueeLbl.isHidden = true
                }else{
                    self.registerBtn.setTitle("Unregister", for: .normal)
                    self.registerBtn.isEnabled = true
                    self.registerBtn.backgroundColor = UIColor(red:0.69412, green:0.23137, blue:0.23922, alpha:1.00000)
                    self.myMarqueeLbl.isHidden = false
                    
                }
            }else{
                self.displayAlert(title: "Registration Failed!", Message: "Failed to register for the event")
                self.registerBtn.setTitle("Register", for: .normal)
                self.registerBtn.isEnabled = true
                self.registerBtn.backgroundColor = UIColor(red:0.57255, green:0.77647, blue:0.44706, alpha:1.00000)
                self.myMarqueeLbl.isHidden = true
                
            }
        }
        
    }
    
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
