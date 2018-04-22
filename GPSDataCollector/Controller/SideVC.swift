//
//  SideVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 4/21/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit

class SideVC: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var myImageView: FancyImageView!
    
    @IBOutlet weak var signOutBtn: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    //MARK:- Properties
    var user:User!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().rearViewRevealWidth = 200
        if let front = self.revealViewController().frontViewController as? AllEventsVC {
            self.user = front.user
        }
        if let imgURL = URL(string: user.profileImage) {
            self.myImageView.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "userPlaceholder"), options: [.continueInBackground,.scaleDownLargeImages], completed: nil)
        }else {
            self.myImageView.image = #imageLiteral(resourceName: "userPlaceholder")
        }
        self.usernameLabel.text = self.user.username
        NotificationCenter.default.addObserver(self, selector: #selector(updateUser(_:)), name: NSNotification.Name(rawValue: "updateUser"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signOutBtn.layer.cornerRadius = 50.0
        
    }
    
    
    //MARK:- Functions
    
    @objc func updateUser(_ notification:NSNotification) {
        if let returnedUser = notification.userInfo!["user"] as? User {
            self.user = returnedUser
        }
    }
    
    
    //MARK:- IBActions
    
    @IBAction func updateProfileBtnTapped(_ sender: Any) {
        let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userProfileVC") as! UserProfileVC
        vc.userName = user.username
        vc.email = user.email
        vc.firstName = user.firstName
        vc.lastName = user.lastName
        vc.height = user.height
        vc.weight = user.weight
        vc.gender = user.gender
        vc.bio = user.bio
        vc.phone = user.phoneNum
        vc.address = user.address
        vc.image = user.profileImage
        vc.token = user.token
        vc.isComingFromEventsVC = true
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func signOutBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
