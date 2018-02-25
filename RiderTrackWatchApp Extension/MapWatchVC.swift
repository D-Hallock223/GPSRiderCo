//
//  MapWatchVC.swift
//  RiderTrackWatchApp Extension
//
//  Created by AKIL KUMAR THOTA on 2/21/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import WatchKit
import MapKit

class MapWatchVC: WKInterfaceController,dataTransmission {
    
    var trackObject:TrackVC!
    
    @IBOutlet var watchMapView: WKInterfaceMap!
    
    var userLocation:CLLocationCoordinate2D!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let wContext = context as! [Any]
        
        trackObject = wContext[0] as! TrackVC
        trackObject.delegate = self
        
        
        self.userLocation = wContext[1] as! CLLocationCoordinate2D
        
        // mapView Setup
        let latdelta:CLLocationDegrees = 0.01
        let londelta:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latdelta, longitudeDelta: londelta)
        let location:CLLocationCoordinate2D = self.userLocation
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        watchMapView.setRegion(region)
        
        watchMapView.addAnnotation(self.userLocation, with: .red)
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        trackObject.delegate = nil
        
    }
    
    func getData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        watchMapView.removeAllAnnotations()
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        watchMapView.setRegion(region)
        watchMapView.addAnnotation(location, with: .red)
    }
    
    
}
