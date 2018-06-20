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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchUser()
    }
    
    //MARK: - Functions
    
    // Function to log user out from Firebase
    @IBAction func logOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
    }
    
    func fetchImage() {
        // set download path
        let filePath = "gs://connect-e83a4.appspot.com/\(uid!).jpg"
        
        let storageRef = Storage.storage().reference(forURL: filePath)
        
        // Download the data, assuming a max size of 1MB
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            
            if let dataUnwrapped = data {
                self.imageView.image = UIImage(data: dataUnwrapped)
            }
        }
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
