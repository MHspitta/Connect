//
//  ProfileViewController.swift
//  Connect
//
//  Created by Michael Hu on 12-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Variables
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    var users: User!
    let uid = Auth.auth().currentUser?.uid
    var userData: [String] = []
    var profileImage: UIImage?
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchUser()
        roundImage(image: imageView)
    }
    
    // Function to push over to menu detail table
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let profileEditViewController = segue.destination as! ProfileEditViewController
            profileEditViewController.userData = userData
            profileEditViewController.profileImage = profileImage
        }
    }
    
    //MARK: - Functions
    
    func changeLayout() {
        imageView.layer.shadowColor = UIColor.darkGray.cgColor
        imageView.layer.shadowRadius = 4
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = CGSize(width: 0, height: -2)
    }
    
    // Function to make image round
    func roundImage(image: UIImageView) {
        image.layer.borderWidth = 1.0
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
    }
    
    // Function to log user out from Firebase
    @IBAction func logOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
    }
    
    // Function to fetch the image from firebase
    func fetchImage() {
        // set download path
        let filePath = "gs://connect-e83a4.appspot.com/\(uid!).jpg"
        
        let storageRef = Storage.storage().reference(forURL: filePath)
        
        // Download the data, assuming a max size of 1MB
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            
            if let dataUnwrapped = data {
                self.imageView.image = UIImage(data: dataUnwrapped)
            } else {
                self.imageView.image = #imageLiteral(resourceName: "blank-profile-picture-973460_960_720")
            }
            
            self.fillUserData()
        }
    }
    
    // Function fill userData
    func fillUserData() {
        self.userData.append(self.nameLabel.text!)
        self.userData.append(self.ageLabel.text!)
        self.userData.append(self.locationLabel.text!)
        self.userData.append(self.mobileLabel.text!)
        
        self.profileImage = self.imageView.image
    }
    
    // Function to fetch user data from firebase
    func fetchUser() {
        
        // Get snapshot of firebase data
        refHandle = ref.child("Users").child(uid!).observe(.value, with: { (snapshot) in
            
            // Check if snapshot isn't nil
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                let user = User(snapshot: snapshot)
                
                self.nameLabel.text = user.name
                self.ageLabel.text = user.age
                self.locationLabel.text = user.location
                self.mobileLabel.text = user.mobile
                self.fetchImage()
            }
        })
    }
}
