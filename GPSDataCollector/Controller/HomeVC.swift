//
//  HomeVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 10/29/17.
//  Copyright © 2017 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import CoreLocation
import WatchConnectivity
import Alamofire
import SwiftyJSON
import KRProgressHUD

protocol SendData:class {
    
    func receiveAndUpdate(location:CLLocation?)
}

protocol raceOverCloseProtocol:class {
    func closeWidow()
}

class HomeVC: UIViewController,CLLocationManagerDelegate {
    
    
    
    @IBOutlet weak var startUpdateBtn: FancyButton!
    @IBOutlet weak var mapInfoLbl: UILabel!
    @IBOutlet weak var currentUserNameTxtLbl: UILabel!
    @IBOutlet weak var mapVCBtn: UIButton!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    
    
    
    var session:WCSession?
    var user:User?
    var locationPoint:CLLocation?
    var locationManager:CLLocationManager!
    private var _latitude:CLLocationDegrees!
    private var _longitude:CLLocationDegrees!
    var username:String?
    var stopUpdating:Bool!
    var raceNotStarted = true
    var selectedEvent:Event!
    var firstTime = true
    var previousRouteCoordinates = [CLLocationCoordinate2D]()
    
    weak var protocolDelegate:SendData?
    weak var closeDelegate:raceOverCloseProtocol?
    
    
    var fixedStartPoint:CLLocation!
    //    var lastTimeStamp:Date?
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationSetup()
        self._latitude = CLLocationDegrees()
        self._longitude = CLLocationDegrees()
        self.currentUserNameTxtLbl.text = "Hello \((self.user?.username)!)"
        stopUpdating = false
        startUpdateBtn.isEnabled = false
        fixedStartPoint = CLLocation(latitude: selectedEvent.trackCoordinateLat, longitude: selectedEvent.trackCoordinateLong)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapVCBtn.layer.cornerRadius = 75.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if firstTime {
            getMapData()
        }
        
    }
    
    func getMapData() {
        firstTime = false
        KRProgressHUD.show(withMessage: "Fetching Map Information", completion: nil)
        getCoordinatesFromDownloadURL(fileURL: "https://firebasestorage.googleapis.com/v0/b/gpsdatacollector-44050.appspot.com/o/1.gpx?alt=media&token=a33334b0-d6c1-40b5-88fd-82bb61568455") { (Success) in
            if Success {
                KRProgressHUD.showSuccess(withMessage: "Successfully fetched map information")
                print("Successfully downloaded map path")
                KRProgressHUD.show(withMessage: "Checking your location!", completion: {
                    if self.reachedRaceCheck() {
                        self.raceNotStarted = false
                        KRProgressHUD.showSuccess(withMessage: "You are at the right location!")
                        self.startUpdateBtn.isEnabled = true
                        self.startUpdateBtn.setTitle("Start Updating Location", for: .normal)
                        self.locationManager.stopUpdatingLocation()
                    } else {
                        self.startUpdateBtn.isEnabled = true
                        KRProgressHUD.showInfo(withMessage: "Please go to the start of the race")
                        self.startUpdateBtn.setTitle("Check location again", for: .normal)
                    }
                })
                
            }else{
                KRProgressHUD.showError(withMessage: "Failed to fetch map information")
                self.startUpdateBtn.setTitle("Fetch Again", for: .normal)
                print("failed downloadung map path")
            }
        }
    }
    
    fileprivate func locationSetup() {
        
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {return}
        self.locationPoint = location
        //        print(self.locationPoint)
        if raceNotStarted {
            return
        }
        if raceEndCheck(location: location) {
            closeDelegate?.closeWidow()
            raceEndAlert()
            return
        }
        self.latitudeLbl.text = "\(location.coordinate.latitude)" + "°"
        self.longitudeLbl.text = "\(location.coordinate.longitude)" + "°"
        sendDataToserver()
        guard let delegate = protocolDelegate else {return}
        delegate.receiveAndUpdate(location: location)
        //        if !timeChecker(){
        //            return
        //        }
        
        
    }
    
    //    func timeChecker() -> Bool {
    //        let now = Date()
    //        let interval = (self.lastTimeStamp != nil) ? now.timeIntervalSince(self.lastTimeStamp!) : 0.0
    //        if (self.lastTimeStamp == nil || interval >= 60) {
    //            self.lastTimeStamp = now
    //            return true
    //        } else {
    //            return false
    //        }
    //    }
    
    
    func raceEndCheck(location:CLLocation) -> Bool {
        let finalDestination = self.previousRouteCoordinates[self.previousRouteCoordinates.count - 1]
        let endClLocation = CLLocation(latitude: finalDestination.latitude, longitude: finalDestination.longitude)
        
        let distance = location.distance(from: endClLocation)
        if distance < 1.0 {
            return true
        }
        return false
        
    }
    
    func raceEndAlert() {
        let alert = UIAlertController(title: "Race Completed", message: "You have successfully completed the race", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
            self.locationManager.stopUpdatingLocation()
            self.sendRaceOverMessageToServer()
            self.user = nil
            self.session?.sendMessage(["loggedIn":false], replyHandler: nil, errorHandler: { (error) in
                self.displayAlert(title: "Error Occured", Message: error.localizedDescription)
                return
            })
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    func sendRaceOverMessageToServer() {
        print("race over message sent")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  let destination = segue.destination as? MapVC else {return}
        destination.homeVC = self
        if let locationPoint = self.locationPoint {
            destination.locationPoint = locationPoint
            destination.username = username
            destination.routeCoordinates = self.previousRouteCoordinates
        }
    }
    
    @objc func sendDataToserver() {
        
        guard let sendURL = URL(string: URL_SEND_DATA_TO_SERVER) else {
            self.displayAlert(title: "Error", Message: "Error sending data to the server")
            return}
        let distanceField = self.locationPoint?.distance(from: fixedStartPoint).rounded()
        let parameters:[String:Any] = ["eventid":self.selectedEvent.id,
                                       "lat":"\(self.locationPoint?.coordinate.latitude ?? 0.0)",
            "lng":"\(self.locationPoint?.coordinate.longitude ?? 0.0)",
            "speed":"\(self.locationPoint?.speed ?? 0.0)",
            "alt":"\(self.locationPoint?.altitude ?? 0)",
            "distLeft":"\(distanceField!)"]
        let headers = ["Content-Type":"application/x-www-form-urlencoded",
                       "Authorization":"Bearer \(self.user?.token ?? "")"]
        
        Alamofire.request(sendURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess{
                let json = try! JSON(data: response.data!)
                let result = json["result"].boolValue
                if result == true {
                    print("Data successfully sent to the server")
                }else{
                    print("Error sending data inside")
                }
            }else{
                print("Error sending data outside")
            }
        }
    }
    
    
    
    func callAlert(title:String,Message:String) {
        let alertVC = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertVC.addAction(action)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func reachedRaceCheck() -> Bool {
        let userCurrentLocation = self.locationPoint
        let startPoint = self.previousRouteCoordinates[0]
        let startClLocation = CLLocation(latitude: startPoint.latitude, longitude: startPoint.longitude)
        
        let distance = (userCurrentLocation?.distance(from: startClLocation))!
        if distance < 100.0 {
            return true
        }
        return false
    }
    
    @IBAction func startUpdateBtnPressd(_ sender: Any) {
        if startUpdateBtn.titleLabel?.text == "Fetch Again"{
            getMapData()
            return
        }
        if startUpdateBtn.titleLabel?.text == "Check location again" {
            if self.reachedRaceCheck() {
                self.raceNotStarted = false
                KRProgressHUD.showSuccess(withMessage: "You are at the right location!")
                self.startUpdateBtn.isEnabled = true
                self.startUpdateBtn.setTitle("Start Updating Location", for: .normal)
                self.locationManager.stopUpdatingLocation()
            } else {
                KRProgressHUD.showInfo(withMessage: "Please go to the start of the race")
            }
            return
        }
        if !stopUpdating {
            stopUpdating = true
            startUpdateBtn.setTitle("Stop Updating Location", for: .normal)
            mapVCBtn.isHidden = false
            mapInfoLbl.isHidden = false
            self.username = user?.email
            locationManager.startUpdatingLocation()
            
        } else {
            stopUpdating = false
            startUpdateBtn.setTitle("Start Updating Location", for: .normal)
            mapVCBtn.isHidden = true
            mapInfoLbl.isHidden = true
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signOutBtnPrssd(_ sender: Any) {
        displayLogOutAlert()
    }
    
    func displayAlert(title:String,Message:String) {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func displayLogOutAlert() {
        let alert = UIAlertController(title: "Are you sure you want to quit?", message: "Click 'OK' to confirm.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive) { (action) in
            self.locationManager.stopUpdatingLocation()
            self.user = nil
            self.session?.sendMessage(["loggedIn":false], replyHandler: nil, errorHandler: { (error) in
                self.displayAlert(title: "Error Occured", Message: error.localizedDescription)
                return
            })
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension HomeVC:XMLParserDelegate {
    
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
            self.previousRouteCoordinates.append(point)
        }
    }
}

