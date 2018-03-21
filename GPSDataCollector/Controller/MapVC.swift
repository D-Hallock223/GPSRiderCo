//
//  MapVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 10/29/17.
//  Copyright © 2017 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import MapKit
//
class MapVC: UIViewController,SendData,UIScrollViewDelegate,MKMapViewDelegate {
    
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
    
    
    
    //
    let routeCoordinates = [[34.4313,-118.59890],[34.4274,-118.60246],[34.4268,-118.60181],[34.4202,-118.6004],[34.42013,-118.59239],[34.42049,-118.59051],[34.42305,-118.59276],[34.42557,-118.59289],[34.42739,-118.59171]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        myMapView.delegate = self
        exampleTest()
        
        
        
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
    
    //
    func exampleTest() {
        
        let resCoord2dArr = allCoordinates()
        let mkPolyline = MKPolyline(coordinates: resCoord2dArr, count: resCoord2dArr.count)
        myMapView.add(mkPolyline)
        for x in resCoord2dArr{
            let anno = MKPointAnnotation()
            anno.coordinate = x
            myMapView.addAnnotation(anno)
        }
    }
    //
    func allCoordinates() -> [CLLocationCoordinate2D] {
        var resCoord2dArr = [CLLocationCoordinate2D]()
        for x in self.routeCoordinates {
            let lat = x[0]
            let long = x[1]
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            resCoord2dArr.append(coordinate)
        }
        return resCoord2dArr
    }
    
    //
    func exampleTest2() {
        let resCoord2dArr = allCoordinates()
        for x in 0..<resCoord2dArr.count - 1 {
            let p1 = resCoord2dArr[x]
            let p2 = resCoord2dArr[x+1]
            drawDirectionFunction(point1: p1, point2: p2)
        }

    }
    
    func drawDirectionFunction(point1:CLLocationCoordinate2D,point2:CLLocationCoordinate2D) {
                let directionRequest = MKDirectionsRequest()
                directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: point1))
                directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: point2))
                directionRequest.transportType = .automobile
        
                // Calculate the direction
                let directions = MKDirections(request: directionRequest)
        
                directions.calculate {
                    (response, error) -> Void in
        
                    guard let response = response else {
                        if let error = error {
                            print("Error: \(error)")
                        }
        
                        return
                    }
        
                    let route = response.routes[0]
        
                    self.myMapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                    
//                    let rect = route.polyline.boundingMapRect
//                    self.myMapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
                }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
    
        
        renderer.strokeColor = UIColor.blue
        
        renderer.lineWidth = 5.0
        
        return renderer
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



    
    

    

