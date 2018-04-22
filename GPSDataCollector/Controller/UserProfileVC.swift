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
import SDWebImage



class UserProfileVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    //MARK:- IBOutletes
    
    @IBOutlet weak var selectImgBtn: UIButton!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var firstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var heightTxtField: UITextField!
    @IBOutlet weak var weightTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var bioTxtView: UITextView!
    
    @IBOutlet weak var finishBtn: FancyButton!
    @IBOutlet weak var editIconBtn: UIButton!
    
    //MARK:- Properties
    var isComingFromEventsVC:Bool!
    
    var userName:String!
    var email:String!
    var password:String?
    
    var keyBoardPresent = false
    
    // iFComingfromEVentsVC
    var firstName:String?
    var lastName:String?
    var height:Double?
    var weight:Double?
    var gender:String?
    var bio:String?
    var phone:String?
    var address:String?
    var image:String?
    var token:String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserProfileVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UserProfileVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if isComingFromEventsVC {
            toggleButton(toggle: false)
            self.finishBtn.isHidden = true
            self.finishBtn.setTitle("Update", for: .normal)
            self.editIconBtn.isHidden = false
//            if let imgURL = URL(string: image!) {
//                self.myImageView.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "userPlaceholder"), options: [.continueInBackground,.scaleDownLargeImages], completed: nil)
//            }else {
//                self.myImageView.image = #imageLiteral(resourceName: "userPlaceholder")
//            }
            if let imgURL = URL(string: image!) {
                self.myImageView.sd_setShowActivityIndicatorView(true)
                self.myImageView.sd_setIndicatorStyle(.gray)
                self.myImageView.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "userPlaceholder"), options: [.avoidAutoSetImage,.continueInBackground,.scaleDownLargeImages], completed: { (image, error, cache, url) in
                    
                    UIView.transition(with: self.view, duration: 1.35, options: .transitionCrossDissolve, animations: {
                        self.myImageView.image = image
                    }, completion: nil)
                })
            }else {
                self.myImageView.image = #imageLiteral(resourceName: "userPlaceholder")
            }
            self.firstNameTxtField.text = firstName!
            self.lastNameTxtField.text = lastName!
            self.heightTxtField.text = "\(height!)"
            self.weightTxtField.text = "\(weight!)"
            if gender! == "Male" {
                self.genderSegmentControl.selectedSegmentIndex = 0
            }else{
                self.genderSegmentControl.selectedSegmentIndex = 1
            }
            self.bioTxtView.text = bio!
            self.phoneTxtField.text = phone!
            self.addressTxtField.text = address!
            
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    //MARK:- Functions
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !(keyBoardPresent) {
            self.keyBoardPresent = true
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0{
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if keyBoardPresent {
            self.keyBoardPresent = false
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0{
                    self.view.frame.origin.y += keyboardSize.height
                }
            }
        }
    }
    
    func toggleButton(toggle:Bool) {
        self.selectImgBtn.isEnabled = toggle
        self.firstNameTxtField.isEnabled = toggle
        self.lastNameTxtField.isEnabled = toggle
        self.heightTxtField.isEnabled = toggle
        self.weightTxtField.isEnabled = toggle
        self.genderSegmentControl.isEnabled = toggle
        self.phoneTxtField.isEnabled = toggle
        self.addressTxtField.isEnabled = toggle
        self.bioTxtView.isEditable = toggle
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func animation(layer:CALayer){
        let transformScaleXyAnimation = CASpringAnimation()
        transformScaleXyAnimation.beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) + 0.000001
        transformScaleXyAnimation.duration = 0.5
        transformScaleXyAnimation.autoreverses = true
        transformScaleXyAnimation.fillMode = kCAFillModeForwards
        transformScaleXyAnimation.isRemovedOnCompletion = false
        transformScaleXyAnimation.keyPath = "transform.scale.xy"
        transformScaleXyAnimation.toValue = 1.3
        transformScaleXyAnimation.fromValue = 1
        transformScaleXyAnimation.stiffness = 200
        transformScaleXyAnimation.damping = 10
        transformScaleXyAnimation.mass = 0.7
        transformScaleXyAnimation.initialVelocity = 4
        
        layer.add(transformScaleXyAnimation, forKey: "transformScaleXyAnimation")
    }
    
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SWRevealViewController {
            let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "allEventsVC") as! AllEventsVC
            destination.setFront(vc, animated: true)
            if let _ = destination.frontViewController as? AllEventsVC {
                if let sen = sender as? User {
                    vc.user = sen
                }
            }
        } else {
            print("this is wrong route 2i493399393")
        }
    }
    
    
    //MARK:- IBActions
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func editIconBtnTapped(_ sender: Any) {
        let layer = self.finishBtn.layer
        animation(layer: layer)
        self.finishBtn.isHidden = false
        toggleButton(toggle: true)
    }
    
    
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
        
        if finishBtn.titleLabel?.text == "Update" {
            
            KRProgressHUD.show(withMessage: "Updating..", completion: {
                DataSource.sharedInstance.uploadImageToFirebase(image: self.myImageView.image!, completion: { (success, url) in
                    if !success {
                        KRProgressHUD.showError(withMessage: "Error while uploading your image")
                        return
                    }
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
                        
                        Authentication.sharedInstance.updateUserInformation(token: self.token!, parameters: parameters, completion: { (success, returnedUser) in
                            if !success {
                                KRProgressHUD.showError(withMessage: "Error Occured.Please try again!")
                                return
                            }
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUser"), object: nil, userInfo: ["user":returnedUser!])
                            KRProgressHUD.showSuccess(withMessage: "Successfully Updated")
                            
                            self.finishBtn.isHidden = true
                        })
                })
            })
            
            
        } else {
            
            KRProgressHUD.show()
            
            
            Authentication.sharedInstance.signInuser(userName: userName, email: email, password: password!) { (success, token) in
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
                                self.performSegue(withIdentifier: "SWReveal", sender: returnedUser)
                                
                            })
                        })
                    })
                })
            }
        }
    }
}
