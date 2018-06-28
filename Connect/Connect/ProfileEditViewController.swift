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
    
    //MARK: - Variables
    
    var imagePicker: UIImagePickerController!
    let uid = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    var userData: [String]!
    var profileImage: UIImage!
    var check:Int = 0
    
    //MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var ageInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var mobileInput: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        self.hideKeyboardWhenTappedAround()
        
        // Image picker
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        roundImage(image: imageView)
        
        imageView.image = profileImage
        
        // Check if there is user data
        if userData != [] {
            preFillUserData()
        }
    }
    
    //MARK: - Functions
    
    // Function to make image round
    func roundImage(image: UIImageView) {
        image.layer.borderWidth = 1.0
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
    }
    
    // Button tap to change image
    @IBAction func changeImage(_ sender: UIButton) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Button save pressed
    @IBAction func saveChanges(_ sender: UIButton) {
        uploadData()
        
        // Check if all fields all filled
        if check == 1 {
            createAlert(title: "Congratulations!", message: "Your profile is succesfully updated!")
        }
    }
    
    // Function to prefill user data in text input fields
    func preFillUserData() {
        nameInput.text = userData[0]
        ageInput.text = userData[1]
        locationInput.text = userData[2]
        mobileInput.text = userData[3]
        bioTextView.text = userData[4]
    }
    
    // Upload data to firebase
    func uploadData() {
        guard let name  = nameInput.text else {
            createAlert(title: "Attention", message: "Please fill in all the empty fields to continue")
            return
        }
        guard let age = ageInput.text else {
            createAlert(title: "Attention", message: "Please fill in all the empty fields to continue")
            return
        }
        guard let location = locationInput.text else {
            createAlert(title: "Attention", message: "Please fill in all the empty fields to continue")
            return
        }
        guard let mobile = mobileInput.text else {
            createAlert(title: "Attention", message: "Please fill in all the empty fields to continue")
            return
        }
        guard let image = imageView.image else {
            createAlert(title: "Attention", message: "Please fill in all the empty fields to continue")
            return
        }
        guard let bio = bioTextView.text else {
            createAlert(title: "Attention", message: "Please fill in all the empty fields to continue")
            return
        }
        
        // Check which user is logged in
        let uid = Auth.auth().currentUser?.uid
        
        // Check for all inputs
        if nameInput.text != "" && ageInput.text != "" && locationInput.text != "" && mobileInput.text != "" {
            
            // Send all data to Firebase
            ref.child("Users").child(uid!).setValue(["name" : name, "age" : age, "location" : location, "mobile" : mobile, "uid" : uid, "bio" : bio])
            
            // Set check variable
//            self.check = 1
        }
//        } else {
//            createAlert(title: "Attention", message: "Please fill in all the empty fields")
//        }
        uploadImagePic(img1: image)
    }
    
    // Function to alert user with popup message
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Function to upload image to firebase
    func uploadImagePic(img1: UIImage) {
        var data = NSData()
        
        // Set size of image uploaded
        data = UIImageJPEGRepresentation(img1, 0.75)! as NSData
        
        // set upload path
        let filePath = "\(uid!).jpg" // path where you wanted to store img in storage
        
        let storageRef = Storage.storage().reference()
        
        storageRef.child(filePath).putData(data as Data)
    }
}
