//
//  Structs.swift
//  Connect
//
//  Created by Michael Hu on 05-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Structs

struct User {
    var username: String
    var name: String
    var password: String
    var bio: String?
    var age: Int?
    var interests: interestType
}

enum interestType {
    case sport
    case games
    case party
    case music
    case chilling
    case culture
    case active
}

struct Activity: Codable {
    var id: String!
    var name: String!
    var ageCategory: String!
    var category: String!
    var endDate: String!
    var time: Double!
    var description: String?
    var participants: Int?
    var location: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "TITEL"
        case ageCategory = "LEEFTIJDCLASSIFICATIE"
        case category = "ACTIVITEITSOORTEN"
        case endDate = "EIND_DATUM"
        case description = "BODY"
        case participants
        case location = "LOCATIETOELICHTING"
    }
}
