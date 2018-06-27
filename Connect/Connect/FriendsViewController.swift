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
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableview: UITableView!
  
    //MARK: - Variables
    
    var ref: DatabaseReference!
    var refHandle: UInt!
    var users: [User] = []
    var userImage: UIImage!
    
    // Current user logged in
    let uid = Auth.auth().currentUser?.uid
    
    //MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        fetchUsers()
    }
    
    // Action segue to go to the friendsDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendsDetailSegue" {
            let friendsDetailViewController = segue.destination as! FriendsDetailViewController
            let index = tableview.indexPathForSelectedRow!.row
            friendsDetailViewController.friend = users[index]
//            friendsDetailViewController.userImage = userImage
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "userFriends", for: indexPath) as! FriendsViewControllerTableViewCell
        let userFriends = users[indexPath.row]
        
        // Update textlabel
        cell.nameLabel.text = userFriends.name
        
//        userImage = fetchImage(uid: userFriends.uid)
        
        cell.profileImage.image = #imageLiteral(resourceName: "blank-profile-picture-973460_960_720")
        
        return cell
    }
    
    // Function to fetch all users
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
    
    func fetchImage(uid: String) {
        // set download path
        let filePath = "gs://connect-e83a4.appspot.com/\(uid).jpg"

        let storageRef = Storage.storage().reference(forURL: filePath)

        // Download the data, assuming a max size of 1MB
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in

            return data
        }
    }
}
