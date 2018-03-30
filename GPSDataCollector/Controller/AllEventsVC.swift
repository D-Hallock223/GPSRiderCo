//
//  AllEventsVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 3/26/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import SDWebImage
import WatchConnectivity

class AllEventsVC: UIViewController,WCSessionDelegate {
    
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySegmentControl: UISegmentedControl!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    
    
    //MARK:- Properties
    
    var allEvents = [Event]()
    var pastEvents = [Event]()
    var upcomingEvent = [Event]()
    var currentRegisteredEvents = [Event]()
    
    
    var refreshControl: UIRefreshControl!
    
    
    var user:User!
    var session:WCSession?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //watch part
        
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        } else {
            displayAlert(title: "Your iPhone is incompatible", Message: "Your iPhone is not able to send message to the watch")
        }
        
        
        
        
        myTableView.dataSource = self
        myTableView.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        let attributedStringColor = [NSAttributedStringKey.foregroundColor : UIColor.white,
                                     NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 18.0)! ]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributedStringColor)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.myTableView.addSubview(refreshControl)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRegisteredEventsForTheCurrentUser()
    }
    
    //MARK:- WCSession protocol Delegate Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    //MARK:- Functions
    
    func getRegisteredEventsForTheCurrentUser() {
        DataSource.sharedInstance.getEventsRegisteredForCurrentUser(token: user.token) { (eventArr) in
            if let arr = eventArr {
                self.currentRegisteredEvents = arr
                self.refreshControl.endRefreshing()
                self.currentRegisteredEvents.sort { (e1, e2) -> Bool in
                    let days1 = RemainingDays(date: e1.date)
                    let days2 = RemainingDays(date: e2.date)
                    return days1! < days2!
                }
                self.myTableView.reloadData()
            }
        }
    }
    
    
    func loadData() {
        myActivityIndicator.startAnimating()
        self.allEvents = []
        self.upcomingEvent = []
        self.pastEvents = []
        self.myTableView.reloadData()
        DataSource.sharedInstance.getAllEvents { (events) in
            if let eventArr = events {
                self.allEvents = eventArr
                self.segregateData()
                self.myTableView.reloadData()
                self.myActivityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc func refresh() {
        if mySegmentControl.selectedSegmentIndex == 0{
            getRegisteredEventsForTheCurrentUser()
        } else {
            loadData()
        }
    }
    
    func segregateData() {
        for event in self.allEvents {
            let eventDateString = event.date
            if let date = Formatter.iso8601.date(from: eventDateString)  {
                if date < Date() {
                    self.pastEvents.append(event)
                } else {
                    self.upcomingEvent.append(event)
                }
            }
        }
        self.upcomingEvent.sort { (e1, e2) -> Bool in
            let days1 = RemainingDays(date: e1.date)
            let days2 = RemainingDays(date: e2.date)
            return days1! < days2!
        }
        self.pastEvents.sort { (e1, e2) -> Bool in
            let days1 = RemainingDays(date: e1.date)
            let days2 = RemainingDays(date: e2.date)
            return days1! < days2!
        }
    }
    
    func displayAlert(title:String,Message:String) {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func checkCurrentEventArr(id:String) -> Bool {
        for event in currentRegisteredEvents {
            if event.id == id {
                return true
            }
        }
        return false
    }
    
    
    //MARK:- IBActions
    
    @IBAction func segmentControlTapped(_ sender: Any) {
        self.myTableView.reloadData()
    }
    
    @IBAction func SignOutBtnTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}


extension AllEventsVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mySegmentControl.selectedSegmentIndex == 0 {
            return self.currentRegisteredEvents.count
        } else if mySegmentControl.selectedSegmentIndex == 1 {
            return self.upcomingEvent.count
        } else {
            return self.pastEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event:Event?
        if mySegmentControl.selectedSegmentIndex == 0 {
            event = currentRegisteredEvents[indexPath.row]
        }else if mySegmentControl.selectedSegmentIndex == 1{
            event = upcomingEvent[indexPath.row]
        } else {
            event = pastEvents[indexPath.row]
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AllEventsCell {
            cell.eventNameLbl.text = event!.name
            let daysremValue = RemainingDays(date: event!.date)
            if let value = daysremValue, value >= 0 {
                if value == 0 {
                    cell.daysRemainingLbl.text = "Happening Today"
                } else {
                    cell.daysRemainingLbl.text = "\(value) days remaining"
                }
            } else {
                cell.daysRemainingLbl.text = "Not Applicable"
            }
            cell.locationLbl.text = event?.location
            if let imgURL = URL(string: event!.eventImgLink) {
                cell.eventsImageView.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [.continueInBackground,.scaleDownLargeImages], completed: nil)
            } else {
                cell.eventsImageView.image = #imageLiteral(resourceName: "placeholder")
            }
            return cell
        } else {
            return AllEventsCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSections: Int = 0
        var youHaveData:Int!
        if mySegmentControl.selectedSegmentIndex == 0 {
            youHaveData = currentRegisteredEvents.count
        } else if mySegmentControl.selectedSegmentIndex == 1 {
            youHaveData = upcomingEvent.count
        } else {
            youHaveData = pastEvents.count
        }
        if youHaveData > 0
        {
            numOfSections            = 1
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            if myActivityIndicator.isAnimating {
                noDataLabel.text = "Loading"
            }else{
                noDataLabel.text = "No data available!"
            }
            noDataLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let event:Event?
        let pastEvent:Bool?
        if mySegmentControl.selectedSegmentIndex == 0 {
            event = currentRegisteredEvents[indexPath.row]
            pastEvent = false
        } else if mySegmentControl.selectedSegmentIndex == 1 {
            event = upcomingEvent[indexPath.row]
            pastEvent = false
        } else {
            event = pastEvents[indexPath.row]
            pastEvent = true
        }
        var isRegistered = false
        if mySegmentControl.selectedSegmentIndex == 0 || checkCurrentEventArr(id: event!.id) {
            isRegistered = true
        }
        performSegue(withIdentifier: "toEventDetailVC", sender: [event!,pastEvent!,isRegistered])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EventDetailVC {
            if let arr = sender as? Array<Any> {
                if let choosenEvent = arr[0] as? Event,let pastEvent = arr[1] as? Bool,let registered = arr[2] as? Bool {
                    destination.event = choosenEvent
                    destination.isPast = pastEvent
                    destination.isRegistered = registered
                    destination.user = self.user
                    destination.session = self.session
                }
            }
        }
    }
    
}
