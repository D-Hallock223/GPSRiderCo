//
//  Camera.swift
//  GPSDataCollector
//
//  Created by AKIL KUMAR THOTA on 4/21/18.
//  Copyright © 2018 AKIL KUMAR THOTA. All rights reserved.
//


import MobileCoreServices
import UIKit
import KRProgressHUD

class Camera {
    
    
    var delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate
    
    init(delegate_: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        
        delegate = delegate_
    }
    
    
    func PresentPhotoLibrary(target: UIViewController, canEdit: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            return
        }
        
        let type = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            imagePicker.sourceType = .photoLibrary
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) {
                
                if (availableTypes as NSArray).contains(type) {
                    
                    /* Set up defaults */
                    imagePicker.mediaTypes = [type]
                    imagePicker.allowsEditing = canEdit
                }
            }
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.sourceType = .savedPhotosAlbum
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum) {
                
                if (availableTypes as NSArray).contains(type) {
                    imagePicker.mediaTypes = [type]
                }
            }
        } else {
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.delegate = delegate
        target.present(imagePicker, animated: true, completion: nil)
        return
    }
    
    
    
    func PresentPhotoCamera(target: UIViewController,  canEdit: Bool) {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            return
        }
        
        let type1 = kUTTypeImage as String
        
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            if let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera) {
                
                if (availableTypes as NSArray).contains(type1) {
                    
                    imagePicker.mediaTypes = [type1]
                    imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                }
            }
            if UIImagePickerController.isCameraDeviceAvailable(.rear) {
                imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.rear
            }
            else if UIImagePickerController.isCameraDeviceAvailable(.front) {
                imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.front
            }
        } else {
            //show alert, no camera available
            KRProgressHUD.showWarning(withMessage: "No Camera available")
            return
        }
        
        imagePicker.allowsEditing = canEdit
        imagePicker.showsCameraControls = true
        imagePicker.delegate = delegate
        target.present(imagePicker, animated: true, completion: nil)
    }
    
}


