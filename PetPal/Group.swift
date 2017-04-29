//
//  Group.swift
//  PetPal
//
//  Created by LING HAO on 4/28/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class Group: NSObject {
    var name: String?
    
    override var description: String {
        if let name = self.name {
            return name
        } else {
            return self.description
        }
    }
}
