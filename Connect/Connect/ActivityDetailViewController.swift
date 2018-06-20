//
//  ActivityDetailViewController.swift
//  Connect
//
//  Created by Michael Hu on 13-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ActivityDetailViewController: UIViewController {
    
    //MARK: - Variables
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    var activity: Activity2!
    
    //MARK: - Outlets
    
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var organiserLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var participantsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var mobileLabel: UILabel!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        updateUI()
    }
    
    //MARK: - Functions
    
    // Function to update the detailview
    func updateUI() {
        activityName.text = activity.activity
        categoryLabel.text = activity.category
        participantsTextView.text = activity.participants
        dateLabel.text = activity.date
        locationLabel.text = activity.location
        descriptionTextField.text = activity.description
        getCreatorData()
    }
    
    // Function to get the creators name
    func getCreatorData() {
        let id = activity.creator
        
        refHandle = ref.child("Users").child(id!).observe(.value, with: { (snapshot) in
            
            // Check if snapshot isn't nil
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                let user = User(snapshot: snapshot)
                self.organiserLabel.text = user.name
                self.mobileLabel.text = user.mobile
            }
        })
    }
}
