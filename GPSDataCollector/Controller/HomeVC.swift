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

class HomeVC: UIViewController,CLLocationManagerDelegate,WCSessionDelegate {
    
    
    
    
    
    
    
    @IBOutlet weak var startUpdateBtn: FancyButton!
    @IBOutlet weak var mapInfoLbl: UILabel!
    @IBOutlet weak var currentUserNameTxtLbl: UILabel!
    @IBOutlet weak var mapVCBtn: UIButton!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    
    
    
    var session:WCSession?
    var mapVCClose:Bool!
    
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
    var lastTimeStamp:Date?
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSetup()
        mapVCClose = false
        
        
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
        
        if mapVCClose {
            raceEndAlert(forWatch: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session?.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session?.delegate = nil
    }
    
    
    // watch session code
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let value = message["close"] as? Bool {
            if value {
                closeDelegate?.closeWidow()
                raceEndAlert(forWatch: true)
            }
        }
    }
    
    
    
    
    func getMapData() {
        firstTime = false
        KRProgressHUD.show(withMessage: "Fetching Map Information", completion: nil)
        getCoordinatesFromDownloadURL(fileURL: selectedEvent.trackFileLink) { (Success) in
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
            raceEndAlert(forWatch: false)
            return
        }
        self.latitudeLbl.text = "\(location.coordinate.latitude.truncate(3))" + "°"
        self.longitudeLbl.text = "\(location.coordinate.longitude.truncate(3))" + "°"

        if timeChecker(){
            sendDataToserver(isForEnd: false)
        }
        guard let delegate = protocolDelegate else {return}
        delegate.receiveAndUpdate(location: location)
    }
    
    func timeChecker() -> Bool {
        let now = Date()
        let interval = (self.lastTimeStamp != nil) ? now.timeIntervalSince(self.lastTimeStamp!) : 0.0
        if (self.lastTimeStamp == nil || interval >= 5) {
            self.lastTimeStamp = now
            return true
        } else {
            return false
        }
    }
    
    
    func raceEndCheck(location:CLLocation) -> Bool {
        let finalDestination = self.previousRouteCoordinates[self.previousRouteCoordinates.count - 1]
        let endClLocation = CLLocation(latitude: finalDestination.latitude, longitude: finalDestination.longitude)
        
        let distance = location.distance(from: endClLocation)
        if distance < CLLocationDistance(exactly: 5.0)! {
            return true
        }
        return false
        
    }
    
    func raceEndAlert(forWatch:Bool) {
        self.sendRaceOverMessageToServer()
        let alert = UIAlertController(title: "Race Completed", message: "You have successfully completed the race", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
            self.user = nil
            if !forWatch {
                self.session?.sendMessage(["loggedIn":false], replyHandler: nil, errorHandler: { (error) in
                    print(error.localizedDescription)
                    return
                })
            }
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    func sendRaceOverMessageToServer() {
        self.locationManager.stopUpdatingLocation()
        sendDataToserver(isForEnd: true)
    }
    
    
    func raceAlreadyCompletedAlert() {
        let alertVC = UIAlertController(title: "Now Calm Down!", message: "You have already completed this race", preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
            self.locationManager.stopUpdatingLocation()
            self.user = nil
            self.session?.sendMessage(["loggedIn":false], replyHandler: nil, errorHandler: { (error) in
                print(error.localizedDescription)
                return
            })
            self.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard  let destination = segue.destination as? MapVC else {return}
        destination.homeVC = self
        if let locationPoint = self.locationPoint {
            destination.locationPoint = locationPoint
            destination.username = username
            destination.routeCoordinates = self.previousRouteCoordinates
            destination.session = self.session
        }
    }
    
    func sendDataToserver(isForEnd:Bool) {
        
        guard let sendURL = URL(string: URL_SEND_DATA_TO_SERVER) else {
            self.displayAlert(title: "Error", Message: "Error sending data to the server")
            return}
        var distanceField = self.locationPoint?.distance(from: fixedStartPoint).rounded()
        distanceField = distanceField! * 0.000621371
        var speed = self.locationPoint?.speed ?? 0.0
        if speed < 0 {
            speed = 0.1
        }
        let parameters:[String:Any]!
        
        let parameters1:[String:Any] = ["eventid":self.selectedEvent.id,
                                       "lat":"\(self.locationPoint?.coordinate.latitude ?? 0.0)",
            "lng":"\(self.locationPoint?.coordinate.longitude ?? 0.0)",
            "speed":"\(speed)",
            "alt":"\(self.locationPoint?.altitude ?? 0)",
            "distLeft":"\(distanceField!)"]
        let parameters2:[String:Any] = ["eventid":self.selectedEvent.id,
                                        "lat":"\(self.locationPoint?.coordinate.latitude ?? 0.0)",
            "lng":"\(self.locationPoint?.coordinate.longitude ?? 0.0)",
            "speed":"\(speed)",
            "alt":"\(self.locationPoint?.altitude ?? 0)",
            "distLeft":"\(distanceField!)",
            "completed":true]
        if isForEnd {
            parameters = parameters2
        }else{
            parameters = parameters1
        }
        let headers = ["Content-Type":"application/x-www-form-urlencoded",
                       "Authorization":"Bearer \(self.user?.token ?? "")"]
        
        Alamofire.request(sendURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.isSuccess{
                let json = try! JSON(data: response.data!)
                let result = json["result"].boolValue
                if result == true {
                    print("Data successfully sent to the server")
                }else{
                    let msg = "activity is already marked completed"
                    let returnMSg = json["status"]["msg"].stringValue
                    print(returnMSg,11111)
                    if msg == returnMSg {
                        self.raceAlreadyCompletedAlert()
                    }else{
                        print("some error occured while sending data")
                    }
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
                print(error.localizedDescription)
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

