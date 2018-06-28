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
    var activity: Activity!
    var idArray: [Id] = []
    
    // Counter for participants
    var counter: Int!
    
    //MARK: - Outlets
    
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var organiserLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var participantsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        updateUI()
    }
    
    //MARK: - Functions
    
    // Function to update the detailview
    func updateUI() {
        updateLabels()
        getCreatorData()
        getPartIds()
        changeBackground()
    }
    
    func updateLabels() {
        activityName.text = activity.activity
        categoryLabel.text = activity.category
        dateLabel.text = activity.date
        locationLabel.text = activity.location
        descriptionTextField.text = activity.description
        activityName.adjustsFontSizeToFitWidth = true
    }
    
    func changeBackground() {
        switch activity.category {
        case "Outdoor Sports":
            self.background.image = #imageLiteral(resourceName: "Bike Rider Top Mountain iPhone 6 Wallpaper")
        case "Chilling":
            self.background.image = #imageLiteral(resourceName: "Chilling")
        case "Game":
            self.background.image = #imageLiteral(resourceName: "gaming")
        case "Movie":
            self.background.image = #imageLiteral(resourceName: "movie")
        case "Football":
            self.background.image = #imageLiteral(resourceName: "football")
        case "Festival":
            self.background.image = #imageLiteral(resourceName: "festival")
        case "Party":
            self.background.image = #imageLiteral(resourceName: "party-1")
        case "Theater":
            self.background.image = #imageLiteral(resourceName: "theater")
        case "Extreme sports":
            self.background.image = #imageLiteral(resourceName: "Extreme")
        case "Water Activities":
            self.background.image = #imageLiteral(resourceName: "water")
        case "Self care":
            self.background.image = #imageLiteral(resourceName: "selfCare")
        case "Running":
            self.background.image = #imageLiteral(resourceName: "running")
        case "Music":
            self.background.image = #imageLiteral(resourceName: "music")
        case "Indoor Sports":
            self.background.image = #imageLiteral(resourceName: "indoor ")
        case "Food":
            self.background.image = #imageLiteral(resourceName: "food")
        case "Car":
            self.background.image = #imageLiteral(resourceName: "car")
        case "Girl's Night":
            self.background.image = #imageLiteral(resourceName: "girlsNight")
        case "Men's Night":
            self.background.image = #imageLiteral(resourceName: "mensNight")
        default:
            self.background.image = #imageLiteral(resourceName: "Swimming")
        }
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
    
    // Function to get the participants uid
    func getPartIds() {
        refHandle = ref.child("Activities").child(activity.activityID).child("participating(uid)").observe(.value, with: { (snapshot) in
            
            if (snapshot.value as? [String:AnyObject]) != nil {
                var idX: [Id] = []
                
                for child in snapshot.children {
                    
                    let partId = Id(snapshot: child as! DataSnapshot)
                    
                    idX.append(partId)
                }
                self.idArray = idX
                self.getPartName()
            }
        })
    }
    
    // Function to get all participating user's name
    func getPartName() {
        refHandle = ref.child("Users").observe(.value , with: { ( snapshot) in
            
            // Counter to count partipants
            self.counter = 0
            
            if (snapshot.value as? [String:AnyObject]) != nil {
                for child in snapshot.children {
                    let user = User(snapshot: child as! DataSnapshot)
                    
                    // Loop trough all participants uid's
                    for id in self.idArray {
                        
                        // Check if user participates
                        if id.id == user.uid! {
                            
                            self.participantsTextView.text.append(user.name + ", ")
                            self.counter = self.counter + 1
                            
                            if self.counter! < Int(self.activity.participants)! {
                                self.counterLabel.text = "\(self.counter!)/\(self.activity.participants!)"
                            } else {
                                self.counterLabel.text = "Full!"
                                self.counterLabel.textColor = .red
                            }
                        }
                    }
                }
            }
        })
    }
}
