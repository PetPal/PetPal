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
    
    init(requestUser: User, startDate: Date, endDate: Date, requestType: RequestType, groups: [Group]) {
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
        if let pfUser = object["acceptUser"] as? PFUser {
            acceptUser = User(pfUser: pfUser)
        }
        
        startDate = object["startDate"] as? Date
        endDate = object["endDate"] as? Date
        requestType = RequestType(rawValue: (object["requestType"] as? Int) ?? 0)!

        // populate the groups
        groups = [Group]()
        if let groupIds = object["groupIds"] as? [String] {
            for id in groupIds {
                if let group = User.currentUser?.getGroup(fromId: id) {
                    groups!.append(group)
                }
            }
        }
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

        //        let relation = requestObject.relation(forKey: "groups")
        //        if let groups = request.groups {
        //            for i in 0 ..< groups.count {
        //                let pfGroup = groups[i].pfObject!
        //                relation.add(pfGroup)
        //            }
        //    
    
        if let groups = groups {
            var groupIds = [String]()
            for group in groups {
                if let id = group.pfObject?.objectId {
                    groupIds.append(id)
                }
            }
            requestObject["groupIds"] = groupIds
        }

        return requestObject
    }
}
