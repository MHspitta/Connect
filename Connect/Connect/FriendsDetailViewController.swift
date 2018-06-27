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
    @IBOutlet weak var partActivitiesTextview: UITextView!
    @IBOutlet weak var bioTextView: UITextView!
    
    //MARK: - Variables
    
    var friend: User!
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle?
    let uid = Auth.auth().currentUser?.uid
    var userImage: UIImage!
    var idArray: [Id] = []
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        updateUI()
        fetchImage()
        roundImage(image: profileImage)
    }
    
    //MARK: - Functions
    
    func changeLayout() {
        profileImage.layer.shadowColor = UIColor.darkGray.cgColor
        profileImage.layer.shadowRadius = 4
        profileImage.layer.shadowOpacity = 1
        profileImage.layer.shadowOffset = CGSize(width: 0, height: -2)
    }
    
    // Function to make image round
    func roundImage(image: UIImageView) {
        image.layer.borderWidth = 1.0
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
    }
    
    // Function to update UIView
    func updateUI() {
        nameLabel.text = friend.name
        ageLabel.text = friend.age
        locationLabel.text = friend.location
        mobileLabel.text = friend.mobile
        bioTextView.text = friend.bio
        fetchActivityId()
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
    
    // Function to fetch all activities that user participate
    func fetchActivityId() {
        
        // Get snapshot of firebase data
        refHandle = ref.child("Users").child(friend.uid!).child("participatingActivities").observe(.value, with: { (snapshot) in
            if (snapshot.value as? [String:AnyObject]) != nil {
                var idX: [Id] = []
                
                for child in snapshot.children {
                    
                    let activityId = Id(snapshot: child as! DataSnapshot)
                    
                    idX.append(activityId)
                }
                self.idArray = idX
                self.fetchPartActivities()
            }
        })
    }
    
    // Function to fetch all participating activities
    func fetchPartActivities() {
        
        refHandle = ref.child("Activities").observe(.value , with: { ( snapshot) in
            
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                // Itereate trough the snapshot and save the data
                for child in snapshot.children {
                    let activity = Activity2(snapshot: child as! DataSnapshot)
                    
                    for id in self.idArray {
                        if id.id == activity.activityID!{
                            self.partActivitiesTextview.text.append(activity.activity + ", ")
                        }
                    }
                }
                self.idArray = []
            }
        })
    }
    
}
