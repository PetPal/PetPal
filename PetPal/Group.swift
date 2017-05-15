//
//  Group.swift
//  PetPal
//
//  Created by LING HAO on 4/28/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse

enum GroupType: Int {
    case publicType
    case privateType
}

class Group: NSObject {
    
    var pfObject: PFObject?
    var name: String?
    var type: GroupType = GroupType.privateType
    var owner: User?
    var timeStamp: Date?
    var overview: String?
    var profileImage : PFFile?
    var location: String?
    var memberCount: Int?

    init(name: String, type: GroupType, owner: User, timeStamp: Date, overview: String, profileImage: PFFile, location: String, memberCount: Int) {
        self.name = name
        self.type = type
        self.owner = User.currentUser
        self.timeStamp = timeStamp
        self.overview = overview
        self.profileImage = profileImage
        self.location = location
        self.memberCount = memberCount
    }
    
    init(object: PFObject) {
        pfObject = object
        name = object["name"] as? String
        type = GroupType(rawValue: (object["groupType"] as? Int) ?? 0)!
        overview = object["description"] as? String
        timeStamp = object.createdAt as Date!
        profileImage = object["groupAvatar"] as? PFFile
        location = object["Location"] as? String
        memberCount = object["memberCount"] as? Int
  
    }

}
