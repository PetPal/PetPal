//
//  Request.swift
//  PetPal
//
//  Created by LING HAO on 4/28/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class Request: NSObject {

    var requestUser: User?
    var acceptUser: User?
    var startDate: Date?
    var endDate: Date?
    var requestType: String?
    var groups: [Group]?
    
    init(requestUser: User, startDate: Date, endDate: Date, requestType: String, groups: [Group]) {
        self.requestUser = requestUser
        self.startDate = startDate
        self.endDate = endDate
        self.requestType = requestType
        self.groups = groups
    }
}
