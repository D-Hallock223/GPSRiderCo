//
//  SignUPVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 2/5/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import WatchConnectivity

class SignUPVC: UIViewController,WCSessionDelegate {
    
    
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var emailtxtFld: UITextField!
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
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }

    @IBAction func signUpBtnPrssd(_ sender: Any) {
        spinner.startAnimating()
        guard let email = emailtxtFld.text,email != "" else {
            displayAlert(title: "Enter the email", Message: "Please enter your email")
            self.spinner.stopAnimating()
            self.emailtxtFld.resignFirstResponder()
            return
        }
        guard let password = passwordTxtFld.text,password != "" else {
            displayAlert(title: "Enter the password", Message: "Please enter your password")
            self.spinner.stopAnimating()
            self.passwordTxtFld.resignFirstResponder()
            return
        }
        guard let username = userNameTxtField.text, username != "" else {
            displayAlert(title: "Enter the username", Message: "Please enter your username")
            self.spinner.stopAnimating()
            self.userNameTxtField.resignFirstResponder()
            return
        }
        
        Authentication.sharedInstance.signInuser(userName: username, email: email, password: password) { (success, returnedUser) in
            self.userNameTxtField.text = ""
            self.passwordTxtFld.text = ""
            self.emailtxtFld.text = ""
            if success {
                guard let user  = returnedUser else {return}
                self.spinner.stopAnimating()
                self.session?.sendMessage(["loggedIn":true,
                                           "username":user.username,
                                           "email":user.email,
                                           "token":user.token], replyHandler: nil, errorHandler: { (error) in
                    print("watch connectivity error occured")
                })
                let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeVC
                vc.user = user
                vc.session = self.session
                self.present(vc, animated: true, completion: nil)
            } else {
                self.displayAlert(title: "ERROR", Message: "Error cccured while signing up")
                self.spinner.stopAnimating()
            }
            self.view.endEditing(true)
        }
    }
    
    @IBAction func goToLoginBtnPrssd(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayAlert(title:String,Message:String) {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
