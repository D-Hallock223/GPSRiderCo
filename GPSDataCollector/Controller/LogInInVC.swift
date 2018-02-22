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

    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var session:WCSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        } else {
            displayAlert(title: "Your iPhone is incompatible", Message: "Your iPhone is not able to send message to the watch")
        }
        
    }
    
    //MARK:- WCSession protocol Delegate Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {

        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
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
            self.session?.sendMessage(["loggedIn":true], replyHandler: nil, errorHandler: { (error) in
                self.displayAlert(title: "Error Occured", Message: error.localizedDescription)
                return
            })
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
