//
//  LogInInVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 2/5/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import Firebase


class LogInInVC: UIViewController {
    
    
    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    @IBAction func logInBtnPrsd(_ sender: Any) {
        spinner.startAnimating()
        guard let email = userNameTxtFld.text,email != "" else {
            displayAlert(title: "Enter the username", Message: "Please enter your username")
            return
        }
        guard let password = passwordTxtFld.text,password != "" else {
            displayAlert(title: "Enter the password", Message: "Please enter your password")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            self.userNameTxtFld.text = ""
            self.passwordTxtFld.text = ""
            if error != nil {
                self.displayAlert(title: "ERROR", Message: "Error while signing in")
                return
            }
            guard let user  = user else {return}
            self.spinner.stopAnimating()
            let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeVC
            vc.user = user
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func displayAlert(title:String,Message:String) {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
