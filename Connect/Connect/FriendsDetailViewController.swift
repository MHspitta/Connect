//
//  FriendsDetailViewController.swift
//  Connect
//
//  Created by Michael Hu on 18-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class FriendsDetailViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    
    //MARK: - Variables
    
    var friend: User!
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    let uid = Auth.auth().currentUser?.uid
    var userImage: UIImage!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        fetchImage()
    }
    
    //MARK: - Functions
    
    func updateUI() {
        nameLabel.text = friend.name
        ageLabel.text = friend.age
        locationLabel.text = friend.location
        mobileLabel.text = friend.mobile
    }
    
    func fetchImage() {
        // set download path
        let filePath = "gs://connect-e83a4.appspot.com/\(friend.uid!).jpg"
        
        let storageRef = Storage.storage().reference(forURL: filePath)
        
        // Download the data, assuming a max size of 1MB
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            
            if let dataUnwrapped = data {
                self.profileImage.image = UIImage(data: dataUnwrapped)
            }
        }
    }
    
}
