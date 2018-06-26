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
    let uid = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    var userData: [String]!
    var profileImage: UIImage!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var ageInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var mobileInput: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
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
        messageLabel.text = "Profile succesfully updated!"
    }
    
    @IBAction func cancelEdit(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toProfileSegue", sender: self)
    }
    
    func preFillUserData() {
        nameInput.text = userData[0]
        ageInput.text = userData[1]
        locationInput.text = userData[2]
        mobileInput.text = userData[3]
        imageView.image = profileImage
    }
    
    // Upload data to firebase
    func uploadData() {
        guard let name  = nameInput.text else {
            messageLabel.text = "Please input name"
            return
        }
        guard let age = ageInput.text else {
            messageLabel.text = "Please input your age"
            return
        }
        guard let location = locationInput.text else {
            messageLabel.text = "Please input your location"
            return
        }
        guard let mobile = mobileInput.text else {
            messageLabel.text = "Please input your mobilenumber"
            return
        }
        guard let image = imageView.image else {
            return
        }
        
        // Check which user is logged in
        let uid = Auth.auth().currentUser?.uid
        
        
        // Send all data to Firebase
        ref.child("Users").child(uid!).setValue(["name" : name, "age" : age, "location" : location, "mobile" : mobile, "uid" : uid])
        
        uploadImagePic(img1: image)

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
