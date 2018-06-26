//
//  ConnectViewController.swift
//  Connect
//
//  Created by Michael Hu on 07-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ConnectViewController: UIViewController {
    
    //MARK: - Variables
    
    var activities: [Activity2] = []
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    var currentActivity: Activity2!
    let uid = Auth.auth().currentUser?.uid
    var keyArray: [String] = []
    var numbers: Int = 0
    var check: Int = 0
    
    //MARK: - Outlets
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var participantsLabel: UILabel!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchActivities()
        changeLayout()
    }
    
    //MARK: - Functions
    
    // Function to change layout
    func changeLayout() {
        card.layer.shadowColor = UIColor.darkGray.cgColor
        card.layer.shadowRadius = 4
        card.layer.shadowOpacity = 1
        card.layer.shadowOffset = CGSize(width: 0, height: -2)
    }
    
    // Function to swipe
    @IBAction func SwipeCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        // Calculate how much the view is dragged and add that to the center
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        // Change the color and image of thumb
        if xFromCenter > 0 {
            thumbImage.image = #imageLiteral(resourceName: "thumbs-up-hand-symbol_318-41939")
            thumbImage.tintColor = UIColor.green
        } else {
            thumbImage.image = #imageLiteral(resourceName: "thumbs-down-512")
            thumbImage.tintColor = UIColor.red
        }
        
        // Change the intensity of the thumb color
        thumbImage.alpha = abs(xFromCenter) / view.center.x
        
        // Restore view to center after gesture ended
        if sender.state == UIGestureRecognizerState.ended {
            
            if card.center.x < 75 {
                
                // Move off to the left side
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }) { ( finished ) in
                    self.resetCard()
                }
                return
                
            } else if card.center.x > (view.frame.width - 75 ) {
                
                // Move off to the right side
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }) { ( finished ) in
                    self.likeActivity()
                    self.resetCard()
                }
                return
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                card.center = self.view.center
                self.thumbImage.alpha = 0
            })
        }
    }
    
    // Function to reset the card
    func resetCard() {
        UIView.animate(withDuration: 0.3, animations: {
            self.card.center = self.view.center
            self.thumbImage.alpha = 0
            self.card.alpha = 1
        })
        self.check = 0
        
        randomActivity()
        
        if check != 1 {
            chooseImage()
        }
    
        activityLabel.text = currentActivity.activity
        locationLabel.text = currentActivity.location
        dateLabel.text = currentActivity.date
        participantsLabel.text = currentActivity.participants
    }

    func chooseImage() {
        switch currentActivity.category {
        case "Outdoor Sports":
            self.cardImage.image = #imageLiteral(resourceName: "Bike Rider Top Mountain iPhone 6 Wallpaper")
        case "Chilling":
            self.cardImage.image = #imageLiteral(resourceName: "Chilling")
        case "Game":
            self.cardImage.image = #imageLiteral(resourceName: "gaming")
        case "Movie":
            self.cardImage.image = #imageLiteral(resourceName: "movie")
        case "Football":
            self.cardImage.image = #imageLiteral(resourceName: "football")
        case "Festival":
            self.cardImage.image = #imageLiteral(resourceName: "festival")
        case "Party":
            self.cardImage.image = #imageLiteral(resourceName: "party-1")
        case "Theater":
            self.cardImage.image = #imageLiteral(resourceName: "theater")
        case "Extreme sports":
            self.cardImage.image = #imageLiteral(resourceName: "Extreme")
        case "Water Activities":
            self.cardImage.image = #imageLiteral(resourceName: "water")
        case "Self care":
            self.cardImage.image = #imageLiteral(resourceName: "selfCare")
        case "Running":
            self.cardImage.image = #imageLiteral(resourceName: "running")
        case "Music":
            self.cardImage.image = #imageLiteral(resourceName: "music")
        case "Indoor Sports":
            self.cardImage.image = #imageLiteral(resourceName: "football")
        case "Food":
            self.cardImage.image = #imageLiteral(resourceName: "food")
        case "Car":
            self.cardImage.image = #imageLiteral(resourceName: "car")
        case "Girl's Night":
            self.cardImage.image = #imageLiteral(resourceName: "girlsNight")
        case "Men's Night":
            self.cardImage.image = #imageLiteral(resourceName: "mensNight")

        default:
            self.cardImage.image = #imageLiteral(resourceName: "Swimming")
        }
    }
    
    // Function to select random activity and remove this
    func randomActivity() {
        let x = arc4random_uniform(UInt32(numbers))
        
        if numbers == 0 {
            activityLabel.text = "Currently no activities available"
            locationLabel.text = ""
            dateLabel.text = ""
            participantsLabel.text = ""
            self.check = 1
        } else {
            currentActivity = activities.remove(at: Int(x))
            self.numbers = self.numbers - 1
        }
    }
    
    // Function to upload all data to firebase when activity is liked
    func likeActivity() {
        // Add activitiy to User database
        ref.child("Users").child(uid!).child("participatingActivities").childByAutoId().setValue(["id" : currentActivity.activityID])
        
        // Add user uid to Acitivity database
        ref.child("Activities").child(currentActivity.activityID).child("participating(uid)").childByAutoId().setValue(["id" : uid])
    }
    
    // Function to fetch all activities
    func fetchActivities() {
        
        // Get snapshot of firebase data
        ref?.child("Activities").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                var activityX: [Activity2] = []
                
                // Itereate trough the snapshot and save the data
                for child in snapshot.children {
                    let activity = Activity2(snapshot: child as! DataSnapshot)
                    activityX.append(activity)
                    self.numbers = self.numbers + 1
                }
                self.activities = activityX
                self.resetCard()
            }
        })
    }
}
