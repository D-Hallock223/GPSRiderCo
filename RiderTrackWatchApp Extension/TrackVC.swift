//
//  TrackVC.swift
//  RiderTrackWatchApp Extension
//
//  Created by AKIL KUMAR THOTA on 2/21/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import WatchKit
import CoreLocation
import WatchConnectivity



protocol dataTransmission:class {
    func getData(latitude:CLLocationDegrees,longitude:CLLocationDegrees)
}

class TrackVC: WKInterfaceController,CLLocationManagerDelegate {
    
    @IBOutlet var latitudeLbl: WKInterfaceLabel!
    @IBOutlet var longitudeLbl: WKInterfaceLabel!
    @IBOutlet var speedLbl: WKInterfaceLabel!
    @IBOutlet var altitudeLbl: WKInterfaceLabel!
    @IBOutlet var distanceLbl: WKInterfaceLabel!
    
    let URL_SEND_DATA_TO_SERVER = "https://athlete-tracker-preprod.herokuapp.com/tracking/saveloc"
    
    
    var locationPoint:CLLocation?
    
    var finalDestination = CLLocation(latitude: (WatchUser.sharedInstance.eventStartPointLat)!, longitude: (WatchUser.sharedInstance.eventStartPointLon)!)
    
    var locationManager:CLLocationManager!
    
    weak var delegate:dataTransmission?
    
    
    var endLocationCoordinate:CLLocation!
    
    var session:WCSession!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.session = context as! WCSession
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        endLocationCoordinate = CLLocation(latitude: WatchUser.sharedInstance.eventEndPointLat!, longitude: WatchUser.sharedInstance.eventEndPointLon!)
        
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location  = locations.last else {
            return
        }
        self.locationPoint = location
        latitudeLbl.setText("\(location.coordinate.latitude.truncate(3))°")
        longitudeLbl.setText("\(location.coordinate.longitude.truncate(3))°")
        speedLbl.setText("\(location.speed.truncate(2)) m/s")
        altitudeLbl.setText("\(location.altitude.truncate(2)) ft")
        distanceLbl.setText("\(Int(location.distance(from: finalDestination))) m")
        if raceEndCheck() {
            sendEndMessageToServer()
            locationManager.stopUpdatingLocation()
            presentController(withName: "endVC", context: session)
            return
        }
        sendDataToserver()
        delegate?.getData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        
    }
    //TODO:- send message to server
    func sendEndMessageToServer() {
        print("end message sent")
    }
    //TODO:- Change end location
    func raceEndCheck() -> Bool {
        endLocationCoordinate = CLLocation(latitude: 43.066844000, longitude: -89.304744000)
        let distance = (self.locationPoint!.distance(from: endLocationCoordinate))
        if distance < CLLocationDistance(exactly: 1.0)! {
            return true
        }
        return false
    }
    
    func sendDataToserver() {
        
        guard let sendURL = URL(string: URL_SEND_DATA_TO_SERVER) else {return}
        
        var request = URLRequest(url: sendURL)
        let id = WatchUser.sharedInstance.participatingEventId!
        guard let location = self.locationPoint else {return}
        let parameters = "eventid=\(id)&lat=\(location.coordinate.latitude)&lng=\(location.coordinate.longitude)&speed=\(location.speed)&alt=\(location.altitude)&distLeft=\(location.distance(from: finalDestination))".data(using:String.Encoding.ascii, allowLossyConversion: false)
        
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(WatchUser.sharedInstance.token!)", forHTTPHeaderField: "Authorization")
        
        request.httpBody = parameters
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                print("urlsession error occured")
                print(error!.localizedDescription)
                return
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                }catch {
                    print(error.localizedDescription)
                }
            } else {
                print("No data available")
            }
        }).resume()
    }
    
    
    @IBAction func mapViewbtnTapped() {
        pushController(withName: "MapVC", context: [self,locationPoint])
    }
    
}
