//
//  User.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 4/28/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var tagLine: String?
    var email: String?
    var password: String?
    //var profileImageURL: String?
    
//    var petCount: Int?
//    var locationCity: String?
//    var locationState: String?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary){
        name = dictionary["name"] as? String
        screenName = dictionary["screenName"] as? String
        tagLine = dictionary["tagline"] as? String
        email = dictionary["email"] as? String
        password = dictionary["password"] as? String
    }
    
    init(newName: String, newScreenName: String, newTagLine: String, newEmail: String, newPassword: String){
        name = newName
        screenName = newScreenName
        tagLine = newTagLine
        email = newEmail
        password = newPassword
    }

}
