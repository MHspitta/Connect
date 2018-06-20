//
//  FriendsViewController.swift
//  Connect
//
//  Created by Michael Hu on 18-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    var ref: DatabaseReference!
    var refHandle: UInt!
    var users: [User] = []
    
    // Current user logged in
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchUsers()
    }
    
    
    // Action segue to go to the friendsDetailViewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendsDetailSegue" {
            let friendsDetailViewController = segue.destination as! FriendsDetailViewController
            let index = tableview.indexPathForSelectedRow!.row
            friendsDetailViewController.friend = users[index]
        }
    }
    
    //MARK: - Functions
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Connect users"
        }
        return ""
    }
    
    // Set number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    // Update the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userFriends", for: indexPath)
        let userFriends = users[indexPath.row]
        
        // Update textlabel
        cell.textLabel?.text = userFriends.name
        
        return cell
    }
    
    func fetchUsers() {
        
        // Get snapshot of firebase data
        refHandle = ref.child("Users").observe(.value, with: { (snapshot) in
            
            // Check if snapshot isn't nil
            if (snapshot.value as? [String:AnyObject]) != nil {
                
                var usersX: [User] = []
                
                for child in snapshot.children {
                    let user = User(snapshot: child as! DataSnapshot)
                    usersX.append(user)
                }
                
                self.users = usersX
                
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        })
    }
}
