//
//  SignUPVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 2/5/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit

class SignUPVC: UIViewController {
    
    @IBOutlet weak var userNametxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signUpBtnPrssd(_ sender: Any) {
        
    }
    
    @IBAction func goToLoginBtnPrssd(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
