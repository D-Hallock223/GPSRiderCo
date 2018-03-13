//
//  UpdateProfileVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 2/6/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import Firebase

class UpdateProfileVC: UIViewController {

    @IBOutlet weak var displayNameTxtFld: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.displayName != nil {
            displayNameTxtFld.text = (Auth.auth().currentUser?.displayName)!
        }
    }

   
    @IBAction func updateBtnTapped(_ sender: Any) {
        spinner.startAnimating()
        guard let displayName = displayNameTxtFld.text, displayName != "" else {
            displayAlert(title: "Error", Message: "Enter the name properly")
            spinner.stopAnimating()
            return}
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges { (error) in
            if error != nil {
                self.displayAlert(title: "Error", Message: (error?.localizedDescription)!)
            } else{
                self.spinner.stopAnimating()
                self.displayDismiss(title: "Success", Message: "Updated Successfully")
            }
            
        }
    }
    
    
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayAlert(title:String,Message:String) {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func displayDismiss(title:String,Message:String) {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
