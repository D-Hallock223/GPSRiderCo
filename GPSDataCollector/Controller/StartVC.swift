//
//  StartVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 4/17/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit

class StartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.945) {
            let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "logInVC") as! LogInInVC
            self.present(vc, animated: true, completion: nil)
        }
       
    }


}
