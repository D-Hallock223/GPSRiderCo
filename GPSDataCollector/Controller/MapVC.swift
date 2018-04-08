//
//  MapVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 10/29/17.
//  Copyright © 2017 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
//
class MapVC: UIViewController,SendData,UIScrollViewDelegate,MKMapViewDelegate {
    
    
    weak var homeVC:HomeVC?
    var username:String?
    var finalDestination = CLLocation(latitude: 33.4484, longitude: 112.07)
    var startAnno:MKPointAnnotation!
    var endAnno:MKPointAnnotation!

    

    
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var altitudeLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var myPageControl: UIPageControl!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var latitudeLbl: UILabel!
    
    var locationPoint:CLLocation!
    
    var routeCoordinates = [CLLocationCoordinate2D]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        myMapView.delegate = self

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
        myMapView.userTrackingMode = .followWithHeading
        
        getCoordinatesFromDownloadURL(fileURL: "https://firebasestorage.googleapis.com/v0/b/gpsdatacollector-44050.appspot.com/o/2.gpx?alt=media&token=dee38451-017e-477e-994f-696a9cc4b340") { (Success) in
            if Success {
                self.drawLinesOnMap()
            }else{
                print("failed")
            }
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        homeVC?.protocolDelegate = nil
        homeVC = nil
    }
    
    func drawLinesOnMap() {
        let startCoordinate = self.routeCoordinates[0]
        let endCoordinate = self.routeCoordinates[self.routeCoordinates.count - 1]
        startAnno = MKPointAnnotation()
        endAnno = MKPointAnnotation()
        startAnno.title = "Start"
        endAnno.title = "End"
        startAnno.coordinate = startCoordinate
        endAnno.coordinate = endCoordinate
        self.myMapView.addAnnotations([startAnno,endAnno])
        let mkPoly = MKPolyline(coordinates: self.routeCoordinates, count: self.routeCoordinates.count)
        self.myMapView.add(mkPoly)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinImage:UIImage!
        
        if annotation.title == "Start" {
            pinImage = UIImage(named: "startPin")
        } else if annotation.title == "End" {
            pinImage = UIImage(named: "finishPin")
        } else {
            return nil
        }
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        anView?.canShowCallout = true
        anView!.image = nil
        
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(size)
        pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        anView?.image = resizedImage

        return anView
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userLocationBtnTapped(_ sender: Any) {
        
        let userLocation = myMapView.userLocation.coordinate
        myMapView.userTrackingMode = .followWithHeading
        
    }
    
    @IBAction func eventLocationBtnTapped(_ sender: Any) {
    
        if let first = self.myMapView.overlays.first {
            let rect = self.myMapView.overlays.reduce(first.boundingMapRect, {MKMapRectUnion($0, $1.boundingMapRect)})
            self.myMapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0), animated: true)
        }

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
        }
    }
}

extension MapVC:XMLParserDelegate {
    
    func getCoordinatesFromDownloadURL(fileURL:String,completion:@escaping (Bool)->()) {
        guard let fileRequestURL = URL(string: fileURL) else {
            print("URL error occured")
            completion(false)
            return
        }
        
        Alamofire.request(fileRequestURL).responseData { (response) in
            if response.result.error != nil {
                print("request error occured")
                completion(false)
                return
            } else {
                let parser = XMLParser(data: response.data!)
                parser.delegate = self
                
                //Parse the data, here the file will be read
                let success = parser.parse()
                
                //Log an error if the parsing failed
                if !success {
                    print("parsing error occured")
                    completion(false)
                    return
                }
                completion(true)
                
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "trkpt" || elementName == "wpt" {
            //Create a World map coordinate from the file
            let lat = attributeDict["lat"]!
            let lon = attributeDict["lon"]!
            let point = CLLocationCoordinate2DMake(CLLocationDegrees(lat)!, CLLocationDegrees(lon)!)
            self.routeCoordinates.append(point)
        }
    }
}



    
    

    

