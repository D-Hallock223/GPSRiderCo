//
//  AllEventsVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 3/26/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import SDWebImage

class AllEventsVC: UIViewController {
    
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySegmentControl: UISegmentedControl!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!

    
    
    //MARK:- Properties
    
    var allEvents = [Event]()
    var pastEvents = [Event]()
    var upcomingEvent = [Event]()
    var refreshControl: UIRefreshControl!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    
    
    //MARK:- Functions
    
    
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
        loadData()
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
    }
    
    
    //MARK:- IBActions
    
    @IBAction func segmentControlTapped(_ sender: Any) {
        self.myTableView.reloadData()
    }
    

}


extension AllEventsVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mySegmentControl.selectedSegmentIndex == 0 {
            return self.upcomingEvent.count
        } else {
            return self.pastEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event:Event?
        if mySegmentControl.selectedSegmentIndex == 0 {
            event = upcomingEvent[indexPath.row]
        }else{
            event = pastEvents[indexPath.row]
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AllEventsCell {
            cell.eventNameLbl.text = event!.name
            let daysremValue = RemainingDays(date: event!.date)
            if let value = daysremValue, value >= 0 {
                cell.daysRemainingLbl.text = "\(value) days remaining"
            } else {
                cell.daysRemainingLbl.text = "\(0) days remaining"
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
            event = upcomingEvent[indexPath.row]
            pastEvent = false
        } else {
            event = pastEvents[indexPath.row]
            pastEvent = true
        }
        performSegue(withIdentifier: "toEventDetailVC", sender: [event!,pastEvent!])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EventDetailVC {
            if let arr = sender as? Array<Any> {
                if let choosenEvent = arr[0] as? Event,let pastEvent = arr[1] as? Bool {
                    destination.event = choosenEvent
                    destination.isPast = pastEvent
                }
            }
        }
    }

}
