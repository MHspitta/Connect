//
//  ActivitiesTableViewController.swift
//  Connect
//
//  Created by Michael Hu on 13-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ActivitiesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: - Variables
    
    var ref: DatabaseReference!
    var refHandle: UInt!
    var keyArray: [String] = []
    
    // Self created activities
    var activities: [Activity2] = []
    
    // Participating activities
    var partActivities: [Activity2] = []
    
    var allActivities: [[Activity2]] = []
    
    var idArray: [Id] = []
    
    // Current user logged in
    let uid = Auth.auth().currentUser?.uid
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchActivities()
    }
    
    // Action segue to go to the ActivityDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selfActivityDetail" {
            let activityDetailViewController = segue.destination as! ActivityDetailViewController
            let index = tableview.indexPathForSelectedRow!.row
            activityDetailViewController.activity = activities[index]
        }
    }
    
    //MARK: - Functions
    
    // Set number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return partActivities.count
    }
    
    // Set number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return allActivities[section].count
        return partActivities.count
    }
    
    // Update the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selfActivities", for: indexPath)
//        let cellText = allActivities[indexPath.section][indexPath.row]
        
        let selfActivities = partActivities[indexPath.row]
        
        // Update textlabel en detail label
        cell.textLabel?.text = selfActivities.activity
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "My created activities"
        }
        if section == 1 {
            return "Upcoming activities"
        }
        if section == 2 {
            return "Liked activities"
        }
        return ""
    }
    
    // Function to delete activity
    func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCellEditingStyle, forRowAt indexPath:
        IndexPath) {
        if editingStyle == .delete {
            getAllKeys()
            
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.ref.child("Activities").child(self.keyArray[indexPath.row]).removeValue()
                self.activities.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.keyArray = []
            })
        }
    }
    
    // Function to get all activity keys from firebase
    func getAllKeys() {
        ref?.child("Activities").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                self.keyArray.append(key)
            }
        })
    }
    
    // Function to swipe a activity
    func tableView(_ tableView: UITableView, canEditRowAt
        indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Function to fetch self (user) created the activities from firebase
    func fetchActivities() {
        
        // Get snapshot of firebase data
        refHandle = ref.child("Activities").observe(.value, with: { (snapshot) in
        
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                var activityX: [Activity2] = []
                
                // Itereate trough the snapshot and save the data
                for child in snapshot.children {
                    let activity = Activity2(snapshot: child as! DataSnapshot)
                    
                    // Only append activities created by user self
                    if self.uid == activity.creator {
                        activityX.append(activity)
                    }
                }
                
                self.activities = activityX
                
                self.allActivities.append(self.activities)
                
                self.fetchActivityId()
                
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        })
    }
    
    // Function to fetch all activities that user participate
    func fetchActivityId() {

        // Get snapshot of firebase data
        refHandle = ref.child("Users").child(uid!).child("participatingActivities").observe(.value, with: { (snapshot) in
            
            if (snapshot.value as? [String:AnyObject]) != nil {
                var activityId: Id!
                
                for child in snapshot.children {
                    
                    activityId = Id(snapshot: child as! DataSnapshot)
                    
                    self.idArray.append(activityId)
                }
                self.fetchPartActivities()
            }
        })
    }
    
    // Function to fetch all participating activities
    func fetchPartActivities() {
        
        refHandle = ref.child("Activities").observe(.value , with: { ( snapshot) in
            
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                var activityX: [Activity2] = []
                
                // Itereate trough the snapshot and save the data
                for child in snapshot.children {
                    let activity = Activity2(snapshot: child as! DataSnapshot)
                    
                    for id in self.idArray {
                        
                        if id.id == activity.activityID!{
                            
                            for i in activityX {
                                
                                if i.activityID != activity.activityID {
                                    activityX.append(activity)
                                }
                            }
                            
                        }
                    }
                }
                
                self.partActivities = activityX
                
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        })
    }
}
