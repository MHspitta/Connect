//
//  Structs.swift
//  Connect
//
//  Created by Michael Hu on 05-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

//MARK: - Structs

struct User: Codable {
    var name: String!
    var age: String!
    var location: String!
    var mobile: String!
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String:AnyObject]
        
        age = snapshotValue["age"] as! String
        location = snapshotValue["location"] as! String
        mobile = snapshotValue["mobile"] as! String
        name = snapshotValue["name"] as! String
    }
}

// Struct for activities from Firebase
struct Activity2: Codable {
    var activity: String!
    var category: String!
    var date: String!
    var location: String!
    var participants: String!
    var description: String!
    var organisor: String!
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String:AnyObject]
        
        activity = snapshotValue["activity"] as! String
        category = snapshotValue["category"] as! String
        date = snapshotValue["date"] as! String
        location = snapshotValue["location"] as! String
        participants = snapshotValue["participants(max)"] as! String
        description = snapshotValue["description"] as! String
//        organisor = snapshotValue["organisor"] as! String
    }
}
