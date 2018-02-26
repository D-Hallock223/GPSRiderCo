//
//  TrackVC.swift
//  RiderTrackWatchApp Extension
//
//  Created by AKIL KUMAR THOTA on 2/21/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import WatchKit
import CoreLocation

protocol dataTransmission:class {
    func getData(latitude:CLLocationDegrees,longitude:CLLocationDegrees)
}

class TrackVC: WKInterfaceController,CLLocationManagerDelegate {
    
    @IBOutlet var latitudeLbl: WKInterfaceLabel!
    @IBOutlet var longitudeLbl: WKInterfaceLabel!
    @IBOutlet var speedLbl: WKInterfaceLabel!
    @IBOutlet var altitudeLbl: WKInterfaceLabel!
    @IBOutlet var distanceLbl: WKInterfaceLabel!
    
    var locationPoint:CLLocationCoordinate2D?
    
    var finalDestination = CLLocation(latitude: 33.4484, longitude: 112.07)
    
    var locationManager:CLLocationManager!
    
    weak var delegate:dataTransmission?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50.0
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        
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
        self.locationPoint = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        latitudeLbl.setText("\(location.coordinate.latitude)")
        longitudeLbl.setText("\(location.coordinate.longitude)")
        speedLbl.setText("\(location.speed) m/s")
        altitudeLbl.setText("\(location.altitude) m")
        distanceLbl.setText("\(Int(location.distance(from: finalDestination))) m")
        delegate?.getData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    
    @IBAction func mapViewbtnTapped() {
        pushController(withName: "MapVC", context: [self,locationPoint])
    }
    
}
