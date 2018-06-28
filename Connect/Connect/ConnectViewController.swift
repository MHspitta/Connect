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
    
    var activities: [Activity] = []
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    var currentActivity: Activity!
    let uid = Auth.auth().currentUser?.uid
    var keyArray: [String] = []
    
    // Counter for number of available activities
    var numbers: Int = 0
    
    // Check for available activities
    var check: Int = 0
    
    // Check for existence of user profile in firebase
    var check2: Int = 0
    
    // Counter for participants
    var counterP: Int = 0
    
    //MARK: - Outlets
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var discriptionView: UIView!
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchActivities()
        changeLayout()
        fetchActivityIds()
    }
    
    //MARK: - Functions
    
    // Function to change layout
    func changeLayout() {
        discriptionView.layer.cornerRadius = 7
        card.layer.cornerRadius = 10
        card.layer.shadowColor = UIColor.darkGray.cgColor
        card.layer.shadowRadius = 10
        card.layer.shadowOpacity = 1
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    // Function to swipe the card with gesture
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
            updateLabels()
        }
        
    }
    
    // Function that updates the labels
    func updateLabels() {
        activityLabel.text = currentActivity.activity
        locationLabel.text = currentActivity.location
        dateLabel.text = currentActivity.date
        participantsLabel.text = currentActivity.participants
    }
    
    // Function to choose image for card
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
            noActivities()
            self.check = 1
        } else {
            currentActivity = activities.remove(at: Int(x))
            self.numbers = self.numbers - 1
        }
    }
    
    // Function for when there are no activities
    func noActivities() {
        activityLabel.text = "Currently no activities available"
        locationLabel.text = ""
        dateLabel.text = ""
        participantsLabel.text = ""
        cardImage.image = #imageLiteral(resourceName: "sad-tears-smiley-minimalism-4k-fz-1280x2120")
    }
    
    // Function to upload all data to firebase when activity is liked
    func likeActivity() {
        
        // Add activitiy to User database
        ref.child("Users").child(uid!).child("participatingActivities").childByAutoId()
            .setValue(["id" : currentActivity.activityID])
        
        // Add user uid to Acitivity database
        ref.child("Activities").child(currentActivity.activityID).child("participating(uid)")
            .childByAutoId().setValue(["id" : uid])
    }
    
    // Function to fetch all activities
    func fetchActivities() {
        
        // Get snapshot of firebase data
        ref?.child("Activities").observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                var activityX: [Activity] = []
                
                // Itereate trough the snapshot and save the data
                for child in snapshot.children {
                    let activity = Activity(snapshot: child as! DataSnapshot)
                    
                    activityX.append(activity)
                    self.numbers = self.numbers + 1
                }
                self.activities = activityX
                self.resetCard()
            }
        })
    }
    
    // Function to fetch all activities that user participate on
    func fetchActivityIds() {
        
        // Get snapshot of firebase data
        refHandle = ref.child("Users").observe(.value, with: { (snapshot) in
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                for child in snapshot.children {
                    let userId = Uid(snapshot: child as! DataSnapshot)
                    
                    if userId.id == self.uid {
                        self.check2 = 1
                    }
                }
            }
            // Pop up alert message if user not registred yet
            if self.check2 != 1 {
                self.createAlert(title: "WELCOME!"
                    , message: "Please update your profile BEFORE using the app!!")
            }
        })
    }
    
    // Function to alert user when not updated profile yet
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message
            , preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default
            , handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
