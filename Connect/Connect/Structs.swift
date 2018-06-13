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

////MARK: - Structs
//
//struct User {
//    var username: String
//    var name: String
//    var password: String
//    var bio: String?
//    var age: Int?
//    var interests: interestType
//}
//
//enum interestType {
//    case sport
//    case games
//    case party
//    case music
//    case chilling
//    case culture
//    case active
//}
//
//struct Activity1: Codable {
//    var id: String!
//    var name: String!
//    var ageCategory: String!
//    var category: String!
//    var endDate: String!
//    var time: Double!
//    var description: String?
//    var participants: Int?
//    var location: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "ID"
//        case name = "TITEL"
//        case ageCategory = "LEEFTIJDCLASSIFICATIE"
//        case category = "ACTIVITEITSOORTEN"
//        case endDate = "EIND_DATUM"
//        case description = "BODY"
//        case participants
//        case location = "LOCATIETOELICHTING"
//    }
//}

//MARK: - Structs

// Struct for activities from Firebase
struct Activity2: Codable {
    var activity: String!
    var category: String!
    var date: String!
    var location: String!
    var participants: String!
    var description: String!
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String:AnyObject]
        
        activity = snapshotValue["activity"] as! String
        category = snapshotValue["category"] as! String
        date = snapshotValue["date"] as! String
        location = snapshotValue["location"] as! String
        participants = snapshotValue["participants(max)"] as! String
        description = snapshotValue["description"] as! String
    }
}
