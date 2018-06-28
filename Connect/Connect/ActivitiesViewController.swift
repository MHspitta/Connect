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

class ActivitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableview: UITableView!
    
    //MARK: - Variables
    
    var ref: DatabaseReference!
    var refHandle: UInt!
    var allActivities = [[Activity]]()
    let sections = ["My created activities", "Participating activities"]
    var idArray: [Id] = []
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
            
            if let indexPath = self.tableview.indexPathForSelectedRow {
                let index = allActivities[indexPath.section][indexPath.row]
                activityDetailViewController.activity = index
            }
        }
    }
    
    //MARK: - Functions
    
    // Set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return allActivities.count
    }
    
    // Set number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allActivities[section].count
    }
    
    // Update the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selfActivities", for: indexPath)
        let cellText = self.allActivities[indexPath.section][indexPath.row]
        
        // Update textlabel
        cell.textLabel?.text = cellText.activity
        
        return cell
    }
    
    // Function to set title headers for sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    // Function to set height of section header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    // Function to fetch self (user) created the activities from firebase
    func fetchActivities() {
        refHandle = ref.child("Activities").observe(.value, with: { (snapshot) in
        
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                // Empty the variables
                var activityX: [Activity] = []
                self.allActivities = []
                
                // Itereate trough the snapshot and save the data
                for child in snapshot.children {
                    let activity = Activity(snapshot: child as! DataSnapshot)
                    
                    // Only append activities created by user self
                    if self.uid == activity.creator {
                        activityX.append(activity)
                    }
                }
                self.allActivities.append(activityX)
                self.allActivities.append([])
                self.fetchActivityId()
                
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        })
    }
    
    // Function to fetch all activities that user participate
    func fetchActivityId() {
        refHandle = ref.child("Users").child(uid!).child("participatingActivities").observe(.value, with: { (snapshot) in
            
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
                
                var activityX: [Activity] = []
                self.allActivities[1] = []

                // Itereate trough the snapshot and save the data
                for child in snapshot.children {
                    let activity = Activity(snapshot: child as! DataSnapshot)
                    
                    for id in self.idArray {
                        
                        // Only append participating activities of user
                        if id.id == activity.activityID!{
                            activityX.append(activity)
                        }
                    }
                }
                self.allActivities[1] = activityX
                self.idArray = []

                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        })
    }
}
