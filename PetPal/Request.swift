//
//  Request.swift
//  PetPal
//
//  Created by LING HAO on 4/28/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse

enum RequestType: Int {
    case boardingType
    case dropInVisitType
}

class Request: NSObject {

    static let requestAdded = NSNotification.Name(rawValue: "requestAdded")

    var pfObject: PFObject?
    var requestUser: User?
    var acceptUser: User?
    var startDate: Date?
    var endDate: Date?
    var requestType: RequestType = RequestType.boardingType
    var groups: [Group]?
    
    init(requestUser: User, startDate: Date, endDate: Date, requestType: RequestType, groups: [Group]?) {
        self.requestUser = requestUser
        self.startDate = startDate
        self.endDate = endDate
        self.requestType = requestType
        self.groups = groups
    }

    init(object: PFObject) {
        pfObject = object
        if let pfUser = object["requestUser"] as? PFUser {
            requestUser = User(pfUser: pfUser)
        }
        if let pfGroup = object["toGroup"] as? PFObject {
            let group = Group(object: pfGroup)
            groups = [group]
        }
        startDate = object["startDate"] as? Date
        endDate = object["endDate"] as? Date
        requestType = RequestType(rawValue: (object["requestType"] as? Int) ?? 0)!
    }
    
    func makePFObject() -> PFObject! {
        let requestObject = PFObject(className: "Request")
        if let startDate = startDate {
            requestObject["startDate"] = startDate
        }
        if let endDate = endDate {
            requestObject["endDate"] = endDate
        }
        if let requestUser = requestUser {
            requestObject["requestUser"] = requestUser.pfUser
        }
        if let acceptUser = acceptUser {
            requestObject["acceptUser"] = acceptUser.pfUser
        }
        requestObject["requestType"] = requestType.rawValue
        if let groups = groups {
            if groups.count > 0 {
                requestObject["toGroup"] = groups[0].pfObject
            }
        }

        return requestObject
    }
}
