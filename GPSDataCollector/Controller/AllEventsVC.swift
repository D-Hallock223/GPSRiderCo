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
import KRProgressHUD

class AllEventsVC: UIViewController,WCSessionDelegate {
    
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySegmentControl: UISegmentedControl!
    
    
    
    //MARK:- Properties
    
    var allEvents = [Event]()
    var pastEvents = [Event]()
    var upcomingEvent = [Event]()
    var currentRegisteredEvents = [Event]()
    
    
    var refreshControl: UIRefreshControl!
    
    
    var user:User!
    var session:WCSession?
    
    var firstTime = true
    
    
    
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

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRegisteredEventsForTheCurrentUser(refresh: false)
        
    }
    
    //MARK:- WCSession protocol Delegate Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    //MARK:- Functions
    
    func getRegisteredEventsForTheCurrentUser(refresh:Bool) {
        
        if firstTime || refresh {
            KRProgressHUD.show(withMessage: "Loading", completion: nil)
        }

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
                if self.firstTime || refresh {
                    KRProgressHUD.dismiss()
                    self.firstTime = false
                }
                self.noLabelCheck()
            }
        }
    }
    
    
    func loadData() {
        KRProgressHUD.show(withMessage: "Loading", completion: nil)
        self.allEvents = []
        self.upcomingEvent = []
        self.pastEvents = []
        self.myTableView.reloadData()
        DataSource.sharedInstance.getAllEvents { (events) in
            if let eventArr = events {
                self.allEvents = eventArr
                self.segregateData()
                self.myTableView.reloadData()
                KRProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                self.noLabelCheck()
            }
        }
    }
    
    @objc func refresh() {
        if mySegmentControl.selectedSegmentIndex == 0{
            getRegisteredEventsForTheCurrentUser(refresh: true)
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
    
    func noLabelCheck() {
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
            myTableView.backgroundView = nil
            myTableView.separatorStyle = .singleLine
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: myTableView.bounds.size.width, height: myTableView.bounds.size.height))
            noDataLabel.text = "No data available!"
            noDataLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            myTableView.backgroundView  = noDataLabel
            myTableView.separatorStyle  = .none
        }
    }
    
    func daysSorter(arr:[Event],completion:@escaping ([Event])->()){
        DispatchQueue.global().async {
            var sortedArr = arr
            sortedArr.sort { (e1, e2) -> Bool in
                let days1 = RemainingDays(date: e1.date)
                let days2 = RemainingDays(date: e2.date)
                return days1! < days2!
            }
            DispatchQueue.main.async {
                completion(sortedArr)
            }
        }
}
    
    func lengthFilterer(arr:[Event],completion:@escaping ([Event])->()){
        DispatchQueue.global().async {
            var sortedArr = arr
            
            sortedArr.sort { (e1, e2) -> Bool in
                return e1.length < e2.length
            }
            DispatchQueue.main.async {
                completion(sortedArr)
            }
        }
    }
    
    func difficultyFilterer(arr:[Event],completion:@escaping ([Event])->()){
        DispatchQueue.global().async {
            var sortedArr = arr
            
            sortedArr.sort { (e1, e2) -> Bool in
                return e1.difficulty < e2.difficulty
            }
            DispatchQueue.main.async {
                completion(sortedArr)
            }
        }
    }
    
    
    
    //MARK:- IBActions
    
    @IBAction func segmentControlTapped(_ sender: Any) {
        self.myTableView.reloadData()
        self.noLabelCheck()
    }
    
    @IBAction func SignOutBtnTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func filterBtnTapped(_ sender: Any) {
        
        let filterAlert = UIAlertController(title: "Filter By", message: nil, preferredStyle: .actionSheet)
        let daysFilter = UIAlertAction(title: "Days remaining", style: .default) { (action) in
            print("days filtered")
            KRProgressHUD.show()
            if self.mySegmentControl.selectedSegmentIndex == 0 {
                self.daysSorter(arr: self.currentRegisteredEvents, completion: { (eventArr) in
                    self.currentRegisteredEvents = eventArr
                    self.myTableView.reloadData()
                    KRProgressHUD.dismiss()
                })
            } else if self.mySegmentControl.selectedSegmentIndex == 1 {
                self.daysSorter(arr: self.upcomingEvent, completion: { (eventArr) in
                    self.upcomingEvent = eventArr
                    self.myTableView.reloadData()
                    KRProgressHUD.dismiss()
                })
            }else {
                self.daysSorter(arr: self.pastEvents, completion: { (eventArr) in
                    self.pastEvents = eventArr
                    self.myTableView.reloadData()
                    KRProgressHUD.dismiss()
                })
            }
        }
        let lengthFilter = UIAlertAction(title: "Length of the track", style: .default) { (action) in
            print("lenfth filtered")
            KRProgressHUD.show()
            if self.mySegmentControl.selectedSegmentIndex == 0 {
                self.lengthFilterer(arr: self.currentRegisteredEvents, completion: { (eventArr) in
                    self.currentRegisteredEvents = eventArr
                    self.myTableView.reloadData()
                    KRProgressHUD.dismiss()
                })
            } else if self.mySegmentControl.selectedSegmentIndex == 1 {
                self.lengthFilterer(arr: self.upcomingEvent, completion: { (eventArr) in
                    self.upcomingEvent = eventArr
                    self.myTableView.reloadData()
                    KRProgressHUD.dismiss()
                })
            }else {
                self.lengthFilterer(arr: self.pastEvents, completion: { (eventArr) in
                    self.pastEvents = eventArr
                    self.myTableView.reloadData()
                    KRProgressHUD.dismiss()
                })
            }
        }
        let difficultyFilter = UIAlertAction(title: "Based on difficulty", style: .default) { (action) in
            print("difficulty filter")
            KRProgressHUD.show()
            if self.mySegmentControl.selectedSegmentIndex == 0 {
                self.difficultyFilterer(arr: self.currentRegisteredEvents, completion: { (eventArr) in
                    self.currentRegisteredEvents = eventArr
                    self.myTableView.reloadData()
                    KRProgressHUD.dismiss()
                })
            } else if self.mySegmentControl.selectedSegmentIndex == 1 {
                self.difficultyFilterer(arr: self.upcomingEvent, completion: { (eventArr) in
                    self.upcomingEvent = eventArr
                    self.myTableView.reloadData()
                    KRProgressHUD.dismiss()
                })
            }else {
                self.difficultyFilterer(arr: self.pastEvents, completion: { (eventArr) in
                    self.pastEvents = eventArr
                    self.myTableView.reloadData()
                    KRProgressHUD.dismiss()
                })
            }
        }
//        let locationFilter = UIAlertAction(title: "Location closest to you", style: .default) { (action) in
//            print("location filter")
//        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            filterAlert.dismiss(animated: true, completion: nil)
        }
        filterAlert.addAction(daysFilter)
        filterAlert.addAction(lengthFilter)
        filterAlert.addAction(difficultyFilter)
//        filterAlert.addAction(locationFilter)
        filterAlert.addAction(cancelAction)
        
        present(filterAlert, animated: true, completion: nil)

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
            cell.separatorInset = UIEdgeInsets.zero
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
            cell.locationLbl.text = event!.location
            cell.lengthLbl.text = "\(event!.length) Miles"
            if event?.difficulty == 0 {
                cell.difficultyLbl.text = "Beginner"
            } else if event?.difficulty == 1{
                cell.difficultyLbl.text = "Medium"
            } else {
                cell.difficultyLbl.text = "Hard"
            }
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
