//
//  PetPalConstants.swift
//  PetPal
//
//  Created by LING HAO on 5/5/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import Foundation

struct PetPalConstants {
    
    static let requestAdded = NSNotification.Name(rawValue: "requestAdded")
    static let requestUpdated = NSNotification.Name(rawValue: "requestUpdated")
    
    static let groupAdded = NSNotification.Name(rawValue: "groupAdded")

    static let userGroupUpdated = NSNotification.Name(rawValue: "userGroupUpdated")
    static let userPetUpdated = NSNotification.Name(rawValue: "userPetUpdated")
    
    static let petAdded = NSNotification.Name(rawValue: "petAdded")
    
}
