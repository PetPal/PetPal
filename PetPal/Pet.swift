//
//  Pet.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 5/7/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse

class Pet: NSObject {

    var pfPet: PFObject?
    var name: String?
    var type: String?
    var age: Int?
    var owner: User?
    
    
    init(petName: String, petType: String, petAge: Int, petOwner: User){
        name = petName
        type = petType
        age = petAge
        owner = petOwner
    }
    
    init(object: PFObject) {
        pfPet = object
        name = object["Name"] as? String
        type = object["Type"] as? String
        age = object["Age"] as? Int
        owner = object["Owner"] as? User
    }
    
    func makePFObject() -> PFObject! {
        let petObject = PFObject(className: "Pet")
        return updatePFObject(petObject: petObject)
    }
    
    func updatePFObject(petObject: PFObject) -> PFObject {
        if let name = name {
            petObject["Name"] = name
        }
        if let type = type {
            petObject["Type"] = type
        }
        if let owner = owner {
            petObject["Owner"] = owner.pfUser
        }
        if let age = age {
            petObject["Age"] = age
        }
        
        return petObject
    }
        
        
}
