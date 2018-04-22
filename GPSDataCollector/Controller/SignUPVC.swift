//
//  SignUPVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 2/5/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import KRProgressHUD

class SignUPVC: UIViewController {
    
    
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var emailtxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    
    @IBAction func signUpBtnPrssd(_ sender: Any) {
        guard let email = emailtxtFld.text,email != "" else {
            displayAlert(title: "Enter the email", Message: "Please enter your email")
            KRProgressHUD.dismiss()
            self.emailtxtFld.resignFirstResponder()
            return
        }
        guard let password = passwordTxtFld.text,password != "" else {
            displayAlert(title: "Enter the password", Message: "Please enter your password")
            KRProgressHUD.dismiss()
            self.passwordTxtFld.resignFirstResponder()
            return
        }
        guard let username = userNameTxtField.text, username != "" else {
            displayAlert(title: "Enter the username", Message: "Please enter your username")
            KRProgressHUD.dismiss()
            self.userNameTxtField.resignFirstResponder()
            return
        }
        
        let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userProfileVC") as! UserProfileVC
        vc.userName = username
        vc.email = email
        vc.password = password
        self.userNameTxtField.text = ""
                    self.passwordTxtFld.text = ""
                    self.emailtxtFld.text = ""
        self.view.endEditing(true)
        self.present(vc, animated: true, completion: nil)

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
