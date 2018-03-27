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
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.dataSource = self
        myTableView.delegate = self
        DataSource.sharedInstance.getAllEvents { (events) in
            if let eventArr = events {
                self.allEvents = eventArr
                self.myTableView.reloadData()
            }
        }
    }
    
    
    
    
    //MARK:- Functions
    
    
    //MARK:- IBActions
    
    @IBAction func segmentControlTapped(_ sender: Any) {
        
    }
    

}


extension AllEventsVC:UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = allEvents[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AllEventsCell {
            cell.eventNameLbl.text = event.name
            if let imgURL = URL(string: event.eventImgLink) {
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
