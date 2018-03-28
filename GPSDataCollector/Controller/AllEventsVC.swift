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
    
    
    
    
    
    //MARK:- Properties
    
    var allEvents = [Event]()
    var pastEvents = [Event]()
    var upcomingEvent = [Event]()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.dataSource = self
        myTableView.delegate = self
        DataSource.sharedInstance.getAllEvents { (events) in
            if let eventArr = events {
                self.allEvents = eventArr
                self.segregateData()
                self.myTableView.reloadData()
            }
        }
    }
    
    
    
    
    //MARK:- Functions
    
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

}
