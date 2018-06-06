------ Classes ------

SignUpViewController --> UIViewController

SwipeScreenViewController --> UIViewController

CreateActivityViewController --> UIViewController
ActivityTableViewController --> UITable UIViewController
DetailActivityViewContoller --> UIViewController

FriendsViewController --> Search bar?

ProfileViewController --> UIViewController

Alles behalve SignUpViewController is gelinkt aan tab bar viewcontroller?

----- Structs -----

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

struct matches?

----- Functions -----  

signUp()  
participate()  
deleteActivity()  
createActivity()  
like()  
dislike()  
search()  
updateUI()

----- API--------  

request -> Request  
Haal alleen de ids van projecten op die nog gaande zijn
GET http://www.uitinnoordholland.nl/api/agenda/activiteiten?onlyIds=true  

Alleen de beschikbare activiteiten ID's krijg je dus binnen.  
Met for loop alle id's eruit vissen en invullen voor complete info   
Request  
GET http://www.uitinnoordholland.nl/api/agenda/activiteiten?id=XXXXXXX  

vb: http://www.uitinnoordholland.nl/api/agenda/activiteiten?id=81327  
JSON --> struct Activity??  


----- Firebase ------

- UserId
  - username
  - password

  - bio
  - age
  - interests
  - matches?

  inloggen met fb:
  https://connect-e83a4.firebaseapp.com/__/auth/handler
