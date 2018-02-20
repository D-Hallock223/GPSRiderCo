//
//  LogInInVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 2/5/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import Firebase
import WatchConnectivity


class LogInInVC: UIViewController,WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activated")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
    }
    
    
    
    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    

    
    let session = WCSession.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session.delegate = self
        session.activate()
        

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
                self.displayAlert(title: "ERROR", Message: (error?.localizedDescription)!)
                self.spinner.stopAnimating()
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
