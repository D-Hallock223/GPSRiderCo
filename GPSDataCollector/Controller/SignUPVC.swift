//
//  SignUPVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 2/5/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit

class SignUPVC: UIViewController {
    
    
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var emailtxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

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
                let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "allEventsVC") as! AllEventsVC
                vc.user = user
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
