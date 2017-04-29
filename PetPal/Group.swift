//
//  Group.swift
//  PetPal
//
//  Created by LING HAO on 4/28/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

enum GroupType: Int {
    case publicType
    case privateType
}

class Group: NSObject {
    
    var name: String?
    var type: GroupType = GroupType.privateType
    var owner: User?
    
    init(name: String, type: GroupType, owner: User) {
        self.name = name
        self.type = type
        self.owner = owner
    }
    
}
