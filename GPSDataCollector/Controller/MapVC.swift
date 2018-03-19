//
//  MapVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 10/29/17.
//  Copyright © 2017 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController,SendData,UIScrollViewDelegate {
    
    fileprivate var locations = [MKPointAnnotation]()
    
    weak var homeVC:HomeVC?
    var username:String?
    var finalDestination = CLLocation(latitude: 33.4484, longitude: 112.07)

    
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var altitudeLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var myPageControl: UIPageControl!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var latitudeLbl: UILabel!
    
    var locationPoint:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.delegate = self
        myScrollView.contentSize = CGSize(width: (UIScreen.main.bounds.width)*2, height: 246)
        
        if let homeVC = homeVC {
            homeVC.protocolDelegate = self
        }


        let latdelta:CLLocationDegrees = 0.01
        let londelta:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latdelta, longitudeDelta: londelta)
        let location:CLLocationCoordinate2D = self.locationPoint.coordinate
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = myScrollView.contentOffset.x / myScrollView.frame.width
        if page == 0.0 || page == 1.0 {
            myPageControl.currentPage = Int(page)
        }
    }
    
    
    
    
    
    func receiveAndUpdate(location:CLLocation?) {
        
        
        if let location = location {
            
            self.latitudeLbl.text = "\(location.coordinate.latitude)"
            self.longitudeLbl.text = "\(location.coordinate.longitude)"
            self.speedLbl.text = "\(location.speed) m/h"
            self.altitudeLbl.text = "\(location.altitude) ft"
            self.distanceLbl.text = "\(location.distance(from: finalDestination)) m"
            
            let location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            self.locations.append(annotation)
            if let name =  username {
                annotation.title = name
            }
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
