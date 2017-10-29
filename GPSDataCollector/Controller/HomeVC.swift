//
//  HomeVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 10/29/17.
//  Copyright © 2017 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController,CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!

    @IBOutlet weak var latitudeLbl: UILabel!
    
    @IBOutlet weak var longitudeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSetup()
    }
    
    fileprivate func locationSetup() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        var status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.latitudeLbl.text = "\(location.coordinate.latitude)" + "°"
        self.longitudeLbl.text = "\(location.coordinate.longitude)" + "°"
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        if UIApplication.shared.applicationState == .active {
        } else {
            print("App is backgrounded. New location is %@", location)
        }
        
    }

   

}

