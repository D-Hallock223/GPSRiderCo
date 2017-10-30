//
//  MapVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 10/29/17.
//  Copyright © 2017 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController,SendData {
    
    fileprivate var locations = [MKPointAnnotation]()
    
    weak var homeVC:HomeVC?
    
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var latitudeLbl: UILabel!
    
    var locationPoint:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let homeVC = homeVC {
            homeVC.protocolDelegate = self
        }
        
        
        let latdelta:CLLocationDegrees = 0.01
        let londelta:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latdelta, longitudeDelta: londelta)
        let location:CLLocationCoordinate2D = self.locationPoint
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        myMapView.setRegion(region, animated: true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        homeVC?.protocolDelegate = nil
        homeVC = nil
    }
    
    
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func receiveAndUpdate(latitude: CLLocationDegrees?, longitude: CLLocationDegrees?) {
        
        
        if let latitude = latitude,let longitude = longitude {
            
            self.latitudeLbl.text = "\(latitude)"
            self.longitudeLbl.text = "\(longitude)"
            
             let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            self.locations.append(annotation)
            myMapView.addAnnotation(annotation)
        
            myMapView.setCenter(location, animated: true)
            
            
            while locations.count > 100 {
                let annotationToRemove = self.locations.first!
                self.locations.remove(at: 0)
                myMapView.removeAnnotation(annotationToRemove)
            }
        }
    }
}
