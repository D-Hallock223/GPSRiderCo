//
//  LogInInVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 2/5/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import KRProgressHUD



class LogInInVC: UIViewController{
    
    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func unwindTOLogInVC(segue:UIStoryboardSegue) {
        
    }
 
    @IBAction func logInBtnPrsd(_ sender: Any) {
        KRProgressHUD.show()
        guard let email = userNameTxtFld.text,email != "" else {
            displayAlert(title: "Enter the email", Message: "Please enter your email")
            KRProgressHUD.dismiss()
            self.userNameTxtFld.resignFirstResponder()
            return
        }
        
        guard let password = passwordTxtFld.text,password != "" else {
            displayAlert(title: "Enter the password", Message: "Please enter your password")
            KRProgressHUD.dismiss()
            self.passwordTxtFld.resignFirstResponder()
            return
        }
        
        Authentication.sharedInstance.logInUser(email: email, password: password) { (success, returnedUser) in
            self.userNameTxtFld.text = ""
            self.passwordTxtFld.text = ""
            if success {
                guard let user  = returnedUser else {return}
                KRProgressHUD.dismiss()
                self.performSegue(withIdentifier: "toswreveal", sender: user)
                
            } else {
                self.displayAlert(title: "ERROR", Message: "Error while logging in")
                KRProgressHUD.dismiss()
            }
            self.view.endEditing(true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SWRevealViewController {
            let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "allEventsVC") as! AllEventsVC
            destination.setFront(vc, animated: true)
            if let _ = destination.frontViewController as? AllEventsVC {
                if let sen = sender as? User {
                    print(sen.firstName,sen.lastName)
                    vc.user = sen
                }
            }
        } else {
            print("this is wrong route 2i493399393")
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
        KRProgressHUD.show()
        Authentication.sharedInstance.forgotPassword(email: email) { (Success) in
            KRProgressHUD.dismiss()
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
