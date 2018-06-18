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
    
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: - Variables
    
    var ref: DatabaseReference!
    var refHandle: UInt!
    var activities: [Activity2] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
//        fetchActivities()
    }
    
    // Set number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    // Update the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selfActivities", for: indexPath)
        let selfActivities = activities[indexPath.row]
        
        // Update textlabel en detail label
        cell.textLabel?.text = selfActivities.activity
        
        return cell
    }
    
    // Action segue to go to the menutableviewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selfActivityDetail" {
            let activityDetailViewController = segue.destination as! ActivityDetailViewController
            let index = tableview.indexPathForSelectedRow!.row
            activityDetailViewController.activity = activities[index]
        }
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
    
    // Function to fetch the activities from firebase
    func fetchActivities() {
        
        // Current user logged in
        let uid = Auth.auth().currentUser?.uid
        
        // Get snapshot of firebase data
        refHandle = ref.child("Activities").child(uid!).child("Created").observe(.value, with: { (snapshot) in
        
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                var activityX: [Activity2] = []
                
                // Itereate trough the snapshot and save the data
                for child in snapshot.children {
                    let activity = Activity2(snapshot: child as! DataSnapshot)
                    activityX.append(activity)
                }
            
                self.activities = activityX
                
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                
            }
            
        })
    }

}
