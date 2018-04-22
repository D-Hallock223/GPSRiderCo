//
//  EnlargeImgVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 4/22/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit

class EnlargeImgVC: UIViewController {
    
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var myImageView: UIImageView!
    
    var img:UIImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()

       self.myImageView.image = img
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 2) {
            self.myImageView.alpha = 1
        }
        
    }
    
    //MARK:- IBActions
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    


}
