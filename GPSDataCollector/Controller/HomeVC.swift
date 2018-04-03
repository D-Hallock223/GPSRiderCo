//
//  HomeVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 10/29/17.
//  Copyright © 2017 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import CoreLocation
import WatchConnectivity
import Alamofire
import SwiftyJSON

protocol SendData:class {
    
    func receiveAndUpdate(location:CLLocation?)
}

class HomeVC: UIViewController,CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var startUpdateBtn: FancyButton!
    @IBOutlet weak var mapInfoLbl: UILabel!
    @IBOutlet weak var currentUserNameTxtLbl: UILabel!
    @IBOutlet weak var mapVCBtn: UIButton!
    
    var session:WCSession?
    var user:User?
    var locationPoint:CLLocation?
    var locationManager:CLLocationManager!
    private var _latitude:CLLocationDegrees!
    private var _longitude:CLLocationDegrees!
    weak var protocolDelegate:SendData?
    var username:String?
    var stopUpdating:Bool!
    
    var selectedEvent:Event!
    
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSetup()
        self._latitude = CLLocationDegrees()
        self._longitude = CLLocationDegrees()
        self.currentUserNameTxtLbl.text = "Hello \((self.user?.username)!)"
        stopUpdating = false
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapVCBtn.layer.cornerRadius = 75.0
        
    }
    
    fileprivate func locationSetup() {
        
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.distanceFilter = 50.0
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        guard let location = locations.last else {return}
        self.locationPoint = location
        self.latitudeLbl.text = "\(location.coordinate.latitude)" + "°"
        self.longitudeLbl.text = "\(location.coordinate.longitude)" + "°"
        
        
        sendDataToserver()
        
        guard let delegate = protocolDelegate else {return}
        delegate.receiveAndUpdate(location: location)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  let destination = segue.destination as? MapVC else {return}
        destination.homeVC = self
        if let locationPoint = self.locationPoint {
            destination.locationPoint = locationPoint
            destination.username = username
        }
    }
    
    //TODO:- Fix sending event id and distance
    @objc func sendDataToserver() {

        guard let sendURL = URL(string: URL_SEND_DATA_TO_SERVER) else {
            self.displayAlert(title: "Error", Message: "Error sending data to the server")
            return}
        let parameters:[String:Any] = ["eventid":self.selectedEvent.id,
                                       "lat":"\(self.locationPoint?.coordinate.latitude ?? 0.0)",
            "lng":"\(self.locationPoint?.coordinate.longitude ?? 0.0)",
            "speed":"\(self.locationPoint?.speed ?? 0.0)",
            "alt":"\(self.locationPoint?.altitude ?? 0)",
            "distLeft":"30000"]
        let headers = ["Content-Type":"application/x-www-form-urlencoded",
                       "Authorization":"Bearer \(self.user?.token ?? "")"]

        Alamofire.request(sendURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess{
                let json = try! JSON(data: response.data!)
                let result = json["result"].stringValue.lowercased()
                if result == "ok" {
                    print("Data successfully sent to the server")
                }else{
                   print("Error sending data")
                }
            }else{
                print("Error sending data")
            }
        }
    }
    
    
    
    func callAlert(title:String,Message:String) {
        let alertVC = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func startUpdateBtnPressd(_ sender: Any) {
        if !stopUpdating {
            stopUpdating = true
            startUpdateBtn.setTitle("Stop Updating Location", for: .normal)
            mapVCBtn.isHidden = false
            mapInfoLbl.isHidden = false
            self.username = user?.email
            locationManager.startUpdatingLocation()
            
        } else {
            stopUpdating = false
            startUpdateBtn.setTitle("Start Updating Location", for: .normal)
            mapVCBtn.isHidden = true
            mapInfoLbl.isHidden = true
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signOutBtnPrssd(_ sender: Any) {
        displayLogOutAlert()
    }
    
    func displayAlert(title:String,Message:String) {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func displayLogOutAlert() {
        let alert = UIAlertController(title: "Are you sure you want to quit?", message: "Click 'OK' to confirm.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive) { (action) in
            self.locationManager.stopUpdatingLocation()
            self.user = nil
            self.session?.sendMessage(["loggedIn":false], replyHandler: nil, errorHandler: { (error) in
                self.displayAlert(title: "Error Occured", Message: error.localizedDescription)
                return
            })
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}

