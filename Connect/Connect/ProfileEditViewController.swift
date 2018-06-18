//
//  ProfileEditViewController.swift
//  Connect
//
//  Created by Michael Hu on 18-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ProfileEditViewController: UIViewController {
    
    var imagePicker: UIImagePickerController!
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var ageInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var mobileInput: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        // Hide keyboard function
        self.hideKeyboardWhenTappedAround()
        
        // Image picker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    // Button tap to change image
    @IBAction func changeImage(_ sender: UIButton) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveChanges(_ sender: UIButton) {
        uploadData()
        messageLabel.text = "Profile succesfully updated!"
    }
    
    @IBAction func cancelEdit(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toProfileSegue", sender: self)
    }
    
    // Upload data to firebase
    func uploadData() {
        guard let name  = nameInput.text else { return }
        guard let age = ageInput.text else { return }
        guard let location = locationInput.text else { return }
        guard let mobile = mobileInput.text else { return }
        //        guard let image = imageView.image else { return }
        
        // Check which user is logged in
        let uid = Auth.auth().currentUser?.uid
    
        // Send all data to Firebase
        ref.child("Users").child(uid!).setValue(["name" : name, "age" : age, "location" : location, "mobile" : mobile])
    }
    
    
    
//    // Function to upload the image to Firebase
//    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("user/\(uid)")
//
//        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
//
//        let metaData = Data()
//        let riversRef = storageRef.child("images/rivers.jpg")
//
//        storageRef.putData(imageData, metadata: metaData) { metaData, error in
//            if error == nil, metaData != nil {
//                if let url = metaData?.downloadURL() {
//                    comletion(url)
//                } else {
//                    completion(nil)
//                }
//                // succes!
//            } else {
//                // failed
//                completion(nil)
//            }
//        }
//    }
    
}
