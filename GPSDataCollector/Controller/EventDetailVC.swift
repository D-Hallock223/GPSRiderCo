//
//  EventDetailVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 3/27/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import SDWebImage


class EventDetailVC: UIViewController,UIScrollViewDelegate {
    
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var myPageIndicator: UIPageControl!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var raceWinnersLbl: UILabel!
    @IBOutlet weak var titleTextLbl: UILabel!
    
    //MARK:- Properties
    
    var event:Event!
    var isPast:Bool!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myScrollView.delegate = self
        myScrollView.contentSize = CGSize(width: (UIScreen.main.bounds.width) * 3, height: 290)
        setupEventData()
    }
    
    //MARK:- Functions
    //TODO:- get events registered by user
    func setupEventData() {
        titleTextLbl.text = event.name
        guard let imgURL = URL(string: event.eventImgLink) else {return}
        eventImageView.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: [.continueInBackground,.scaleDownLargeImages], completed: nil)
        if isPast {
            registerBtn.setTitle("Cannot register now!", for: .normal)
            registerBtn.isEnabled = false
            registerBtn.backgroundColor = UIColor(red:0.39216, green:0.39216, blue:0.39216, alpha:1.00000)
            var num = 1
            var res = ""
            if let winners = event.raceWinners,winners.count > 0 {
                for winner in winners{
                    res.append("\(num). \(winner)")
                    res.append("\n")
                    num += 1
                }
            }
            if res != "" {
                raceWinnersLbl.text = res
            }
        } else {
            
            let randomNum = arc4random_uniform(2)
            if randomNum != 0 {
                registerBtn.setTitle("Registered Already!", for: .normal)
                registerBtn.isEnabled = false
                registerBtn.backgroundColor = UIColor(red:0.39216, green:0.39216, blue:0.39216, alpha:1.00000)
            }
        }
        
        locationLbl.text = event.location
        let normalDate = Formatter.iso8601.date(from: event.date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: normalDate!)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd-MMM-yyyy"
        let myStringafd = formatter.string(from: yourDate!)
        dateLbl.text = myStringafd
        timeLbl.text = event.eventTimeRange
        descriptionLbl.text = event.eventDescription
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = myScrollView.contentOffset.x / myScrollView.frame.width
        if page == 0.0 || page == 1.0 || page == 2.0 {
            myPageIndicator.currentPage = Int(page)
        }
    }
        
        
        
        
        //MARK:- IBActions
        
        @IBAction func registerBtnTapped(_ sender: Any) {
            if registerBtn.isEnabled == false {
                return
            }
            print("registered for the event")
        }
        
        
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
        
}
