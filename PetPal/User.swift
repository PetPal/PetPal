//
//  User.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 4/28/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class User: NSObject {
    
    var pfUser: PFUser?
    
    var name: String?
    var screenName: String?
    var tagLine: String?
    var email: String?
    var password: String?
    var groups: [Group]?
    var userAvatar: PFFile?
    var pets: [Pet]?
    
//    var petCount: Int?
//    var locationCity: String?
//    var locationState: String?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary){
        name = dictionary["name"] as? String
        screenName = dictionary["screenName"] as? String
        email = dictionary["email"] as? String
        password = dictionary["password"] as? String
    }
    
    init(newName: String, newScreenName: String, newEmail: String, newPassword: String){
        name = newName
        screenName = newScreenName
        email = newEmail
        password = newPassword
    }
    
    init(pfUser: PFUser) {
        self.pfUser = pfUser
        name = pfUser.object(forKey: "name") as? String
        screenName = pfUser.username
        email = pfUser.email
        password = pfUser.password
        userAvatar = pfUser.object(forKey: "userAvatar") as? PFFile
    }
    
    func getGroup(fromId id: String) -> Group? {
        if let groups = groups {
            for group in groups {
                if group.pfObject?.objectId == id {
                    return group
                }
            }
        }
        return nil
    }
    
    func addPets(pets: [Pet]) {
        for pet in pets {
            self.pets?.append(pet)
        }
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let objectUser = object as? User {
            return pfUser?.objectId == objectUser.pfUser?.objectId
        }
        return false
    }
    
    // MARK: class vars
    
    private static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                if let pfUser = PFUser.current() {
                    _currentUser = User(pfUser: pfUser)
                    
                    // populate the groups- notification will be sent 
                    PetPalAPIClient.sharedInstance.populateGroups(forUser: _currentUser!)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = nil
        }
    }

}
