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

enum RequestCategory: Int {
    case pendingRequest
    case acceptedRequest
    case task
    case groupRequest
}

class Request: NSObject {

    var pfObject: PFObject?
    var requestUser: User?
    var createdAtDate: Date?
    var acceptUser: User?
    var acceptDate: Date?
    var startDate: Date?
    var endDate: Date?
    var requestType: RequestType = RequestType.boardingType
    var groups: [Group]?
    
    var category: RequestCategory {
        get {
            let isOurRequest = User.currentUser?.isEqual(requestUser)
            let isOurTask = User.currentUser?.isEqual(acceptUser)
            if isOurRequest ?? false {
                if acceptUser == nil {
                    return RequestCategory.pendingRequest
                } else {
                    return RequestCategory.acceptedRequest
                }
            } else if isOurTask ?? false {
                return RequestCategory.task
            } else {
                return RequestCategory.groupRequest
            }
        }
    }
    
    init(requestUser: User, startDate: Date, endDate: Date, requestType: RequestType, groups: [Group]) {
        self.requestUser = requestUser
        self.startDate = startDate
        self.endDate = endDate
        self.requestType = requestType
        self.groups = groups

        self.createdAtDate = Date()
    }

    init(object: PFObject) {
        pfObject = object

        createdAtDate = pfObject?.createdAt

        if let pfUser = object["requestUser"] as? PFUser {
            requestUser = User(pfUser: pfUser)
        }
        if let pfUser = object["acceptUser"] as? PFUser {
            acceptUser = User(pfUser: pfUser)
            acceptDate = object["acceptedDate"] as? Date
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
        return updatePFObject(requestObject: requestObject)
    }
    
    func updatePFObject(requestObject: PFObject) -> PFObject {
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
            requestObject["acceptedDate"] = Date()
        }
        requestObject["requestType"] = requestType.rawValue
        
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
    
    func getTypeString() -> String {
        switch requestType {
        case RequestType.boardingType:
            return "Boarding"
        case RequestType.dropInVisitType:
            return "Drop in visit"
        }
    }
    
    func getCategoryString() -> String {
        switch category {
        case RequestCategory.pendingRequest:
            return "Pending Request"
        case RequestCategory.acceptedRequest:
            return "Accepted Request"
        case RequestCategory.task:
            return "Task"
        case RequestCategory.groupRequest:
            return "Group Request"
        }
    }
}
