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
    
    init(name: String, type: GroupType, owner: User) {
        self.name = name
        self.type = type
        self.owner = owner
    }
    
    init(object: PFObject) {
        pfObject = object
        name = object["name"] as? String
        type = GroupType(rawValue: (object["groupType"] as? Int) ?? 0)!
        
    }

}
