//
//  HomeVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 10/29/17.
//  Copyright © 2017 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import CoreLocation

protocol SendData:class {
    
    func receiveAndUpdate(latitude:CLLocationDegrees?,longitude:CLLocationDegrees?)
}

class HomeVC: UIViewController,CLLocationManagerDelegate {
    
    var locationPoint:CLLocationCoordinate2D?
    var locationManager:CLLocationManager!
    private var _latitude:CLLocationDegrees!
    private var _longitude:CLLocationDegrees!
    weak var protocolDelegate:SendData?
    var username:String?
    var timerOn = false
    
    
    var latitude : CLLocationDegrees {
        get {
            return self._latitude
        }
        set{
            self._latitude = newValue
            
        }
    }
    
    var longitude : CLLocationDegrees {
        get {
            return self._longitude
        }
        set{
            self._longitude = newValue
        }
    }
    
    @IBOutlet weak var nameTxtFld: UITextField!
    
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSetup()
        self._latitude = CLLocationDegrees()
        self._longitude = CLLocationDegrees()
        
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
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.latitudeLbl.text = "\(self.latitude)" + "°"
        self.longitudeLbl.text = "\(self.longitude)" + "°"
        
        print(latitude,longitude)
        
        if UIApplication.shared.applicationState == .active {
        } else {
            print("App is backgrounded. New location is %@", location)
        }
        self.locationPoint = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        guard let delegate = protocolDelegate else {return}
        delegate.receiveAndUpdate(latitude: self.latitude, longitude: self.longitude)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  let destination = segue.destination as? MapVC else {return}
        destination.homeVC = self
        if let locationPoint = self.locationPoint {
            destination.locationPoint = locationPoint
            destination.username = username
        }
    }
    
    @objc func sendDataToserver() {
        
        let parameters:[String:Any] = ["user": username!,
                                       "lat":  Double(self.latitude),
                                       "lng":  Double(self.longitude),
                                       "time": Date().timeIntervalSince1970]
        guard let url = URL(string: "https://savemyloc.herokuapp.com/") else {return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }catch {
                    print(error)
                }
            }
            }.resume()
    }
    
    func callAlert(title:String,Message:String) {
        let alertVC = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func startUpdateBtnPressd(_ sender: Any) {
        let name = nameTxtFld.text
        if name == "" {
            callAlert(title:"Enter Name",Message:"Enter proper value in name text field")
            return
        }
        self.username = name
        locationManager.startUpdatingLocation()
        if timerOn == false {
            Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(sendDataToserver), userInfo: nil, repeats: true)
        }
        timerOn = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
}

