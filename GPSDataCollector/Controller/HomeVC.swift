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
        locationManager.distanceFilter = 100.0
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
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
        }
    }
}

