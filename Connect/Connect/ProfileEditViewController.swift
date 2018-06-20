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
    
    // Button save pressed
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
        guard let image = imageView.image else { return }
        
        // Check which user is logged in
        let uid = Auth.auth().currentUser?.uid
    
        // Send all data to Firebase
        ref.child("Users").child(uid!).setValue(["name" : name, "age" : age, "location" : location, "mobile" : mobile])
        
        uploadImagePic(img1: image)
        
        ref.child("Users").child(uid!).child("friends").setValue(["uid" : "name"])
        ref.child("Users").child(uid!).child("participatingActivities").setValue(["uid" : "activity"])
    }
    
    
    func uploadImagePic(img1: UIImage) {
        var data = NSData()
        data = UIImageJPEGRepresentation(img1, 0.75)! as NSData
        
        // set upload path
        let filePath = "\(uid!).jpg" // path where you wanted to store img in storage
        
        let storageRef = Storage.storage().reference()
        
        storageRef.child(filePath).putData(data as Data)
        
    }
    
    
    
    
//    // Function to upload the image to Firebase
//    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url: URL?)->())) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("user/\(uid)")
//
//        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
//
//        let riversRef = storageRef.child("profile/\(uid).jpg")
//        riversRef.putData(imageData)
//
//    }
    
}
