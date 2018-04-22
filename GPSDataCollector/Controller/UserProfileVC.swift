//
//  UserProfileVC.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 4/21/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//

import UIKit
import FirebaseStorage
import KRProgressHUD



class UserProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    //MARK:- IBOutletes
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var heightTxtField: UITextField!
    @IBOutlet weak var weightTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var bioTxtView: UITextView!
    
    
    //MARK:- Properties
    
    var userName:String!
    var email:String!
    var password:String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    //MARK:- Functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let itemImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.myImageView.image  = itemImage
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func checkAllFields() -> Bool {
        if firstNameTxtField.text != "" && lastNameTxtField.text != "" && heightTxtField.text != "" && weightTxtField.text != "" && phoneTxtField.text != "" && addressTxtField.text != "" && bioTxtView.text != "" {
            return true
        }
        return false
    }
    
    func displayAlert(title:String,Message:String) {
        let alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:- IBActions
    
    @IBAction func imagePickBtnTapped(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = Camera(delegate_: self)
        
        let takePhoto = UIAlertAction(title: "Take a picture", style: .default) { (alert:UIAlertAction) in
            //show camera
            camera.PresentPhotoCamera(target: self, canEdit: true)
        }
        let photoLibrary = UIAlertAction(title: "Select from photo library", style: .default) { (alert:UIAlertAction) in
            // show photo library
            camera.PresentPhotoLibrary(target: self, canEdit: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert:UIAlertAction) in
        }
        
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(photoLibrary)
        optionMenu.addAction(cancel)
        
        present(optionMenu, animated: true, completion: nil)
        
    }
    
    
    @IBAction func finishBtnTapped(_ sender: Any) {
        
        
        if !checkAllFields() {
            displayAlert(title: "Incomplete Information", Message: "Please fill out all the fields!")
            return
        }
        
        KRProgressHUD.show()
        
        
        Authentication.sharedInstance.signInuser(userName: userName, email: email, password: password) { (success, token) in
            if !success {
                KRProgressHUD.showError(withMessage: "Error Occured.Please try again!")
                return
            }
            KRProgressHUD.show(withMessage: "Uploading Image...", completion: {
                DataSource.sharedInstance.uploadImageToFirebase(image: self.myImageView.image!, completion: { (success, url) in
                    if !success {
                        KRProgressHUD.showError(withMessage: "Error while uploading your image")
                        return
                    }
                    KRProgressHUD.show(withMessage: "Finalizing..", completion: {
                        let urlValue = url?.absoluteString ?? ""
                        let genderArr = ["Male","Female"]
                        
                        let parameters:[String:Any] = [
                            "username":self.userName ?? "",
                            "firstName":(self.firstNameTxtField.text)!,
                            "lastName":(self.lastNameTxtField.text)!,
                            "email":self.email ?? "",
                            "height":(Double(self.heightTxtField.text!))!,
                            "weight":(Double(self.weightTxtField.text!))!,
                            "gender":genderArr[self.genderSegmentControl.selectedSegmentIndex],
                            "bio":self.bioTxtView.text ?? "",
                            "phoneNo":(self.phoneTxtField.text)!,
                            "address":(self.addressTxtField.text)!,
                            "image":urlValue
                        ]
                        
                        Authentication.sharedInstance.updateUserInformation(token: token!, parameters: parameters, completion: { (success, returnedUser) in
                            if !success {
                                KRProgressHUD.showError(withMessage: "Error Occured.Please try again!")
                                return
                            }
                            KRProgressHUD.dismiss()
                            let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "allEventsVC") as! AllEventsVC
                            vc.user = returnedUser
                            self.present(vc, animated: true, completion: nil)
                            
                        })
                    })
                })
            })
        }
    }
}
