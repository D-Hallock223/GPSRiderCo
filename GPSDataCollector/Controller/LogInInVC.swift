//
//  LogInInVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 2/5/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
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
            displayAlert(title: "Enter the email", Message: "Please enter your email")
            self.spinner.stopAnimating()
            self.userNameTxtFld.resignFirstResponder()
            return
        }
        
        guard let password = passwordTxtFld.text,password != "" else {
            displayAlert(title: "Enter the password", Message: "Please enter your password")
            self.spinner.stopAnimating()
            self.passwordTxtFld.resignFirstResponder()
            return
        }
        
        Authentication.sharedInstance.logInUser(email: email, password: password) { (success, returnedUser) in
            self.userNameTxtFld.text = ""
            self.passwordTxtFld.text = ""
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
                self.displayAlert(title: "ERROR", Message: "Error while logging in")
                self.spinner.stopAnimating()
            }
            self.view.endEditing(true)
        }
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
    
    @IBAction func forgotPasswordBtnTapped(_ sender: Any) {
        forgotPasswordAlert()
    }
    
    func passwordReset(email:String) {
        Authentication.sharedInstance.forgotPassword(email: email) { (Success) in
            if Success {
                self.displayAlert(title: "Password reset successfull", Message: "A password reset link has been sent to your registered email id")
            }else{
                self.displayAlert(title: "Password reset failed", Message: "Password could not be reseted. Please check your email id and try again")
            }
        }
    }
    
    func forgotPasswordAlert() {
        let alertVC = UIAlertController(title: "Forgot Password", message: "Please enter your email", preferredStyle: .alert)
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "Enter your email here..."
        }
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            let emailtxtField = alertVC.textFields![0]
            guard let value = emailtxtField.text, value != "" else {
                self.displayAlert(title: "Error", Message: "Email cannot be blank")
                return}
            self.passwordReset(email: value)
        }
        let cacelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(action)
        alertVC.addAction(cacelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    
    
    
  
}
