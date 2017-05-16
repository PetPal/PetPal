//
//  Messages.swift
//  PetPal
//
//  Created by Rui Mao on 5/5/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Foundation
import Parse

class Messages {
    var pfObject: PFObject?
    var groupId : String?
    var user1 : User?
    var user2 : User?
    var counter: Int?
    var lastMessage: String?
    var updatedAt: Date?
    
    init(groupId: String, user1: User, user2: User, counter: Int,  lastMessage: String){
        self.groupId = groupId
        self.user1 = user1
        self.user2 = user2
        self.counter = counter
        self.lastMessage = lastMessage
    }
    
    init(conversation: PFObject) {
        self.pfObject = conversation
        self.groupId = conversation["groupId"] as? String
        if let pfUser1 = conversation["user1"] as? PFUser {
            self.user1 = User(pfUser: pfUser1)
        }
        if let pfUser2 = conversation["user2"] as? PFUser {
            self.user2 = User(pfUser: pfUser2)
        }
        self.counter = conversation["counter"] as? Int
        self.lastMessage = conversation["lastMessage"] as? String
        self.updatedAt = conversation.updatedAt
    }
    
    func makePFObject() -> PFObject! {
        let conversationObject = PFObject(className: "Message")
        return updatePFObject(conversationObject: conversationObject)
    }
    
    func updatePFObject(conversationObject: PFObject) -> PFObject {
        if let groupId = groupId {
            conversationObject["groupId"] = groupId
        }
        if let user1 = user1 {
            conversationObject["user1"] = user1.pfUser
        }
        if let user2 = user2 {
            conversationObject["user2"] = user2.pfUser
        }
        if let counter = counter {
            conversationObject["counter"] = counter
        }
        if let lastMessage = lastMessage {
            conversationObject["lastMessage"] = lastMessage
        }
        if let updatedAt = updatedAt  {
            conversationObject["updatedAt"] = updatedAt
        }
        
        return  conversationObject
    }
    
    
    class func startPrivateChat(user1: PFUser, user2: PFUser) -> String {
        let id1 = user1.objectId
        let id2 = user2.objectId
        
        let groupId = getGroupId(id1: id1!, id2: id2!)
        
      
        
        //createMessageItem(user1: user1, user2: user2, groupId: groupId, description: "Test String")
       // createMessageItem(user2, user2: PFUser, groupId: groupId, description: user1["name"] as! String)
        
        return groupId
    }
    
    class func getGroupId(id1: String, id2: String) -> String {
        return (id1 < id2) ? "\(id1)\(id2)" : "\(id2)\(id1)"
    }
    
    /*class func startMultipleChat(_ users: [PFUser]!) -> String {
        var groupId = ""
        let description = ""
        
        var userIds = [String]()
        
        for user in users {
            userIds.append(user.objectId!)
        }
        
        let sorted = userIds.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        
        for userId in sorted {
            groupId = groupId + userId
        }
        
        
        for user in users {
            Messages.createMessageItem(user, groupId: groupId, description: description)
        }
        
        return groupId
    }*/
    
    class func createMessageItem(user1: PFUser, user2: PFUser, groupId: String, counter: Int, lastMessage: String) {
        let query = PFQuery(className: "Message")
        query.whereKey("user", equalTo: user1)
        query.whereKey("groupId", equalTo: groupId)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                if objects!.count == 0 {
                    let message = PFObject(className: "Message")
                    let user1 = User(pfUser: user1)
                    let user2 = User(pfUser: user2)
                    let conversation = Messages(groupId: groupId , user1: user1, user2: user2, counter: counter, lastMessage: "test msg")
                    message["user"] = conversation.user1
                    message["user2"] = conversation.user2
                    message["groupId"] = conversation.groupId
                    message["lastMessage"] = ""
                    message["counter"] = 0
                    message["updatedAt"] = NSDate()
                    message.saveInBackground{
                        (success: Bool, error: Error?) -> Void in
                        if (success) {
                            // The object has been saved.
                            print ("Message has been saved.")
        
                        } else {
                            print ("Error: \(String(describing: error?.localizedDescription))")
                        }
                    }
                }
            }
        }
    }
    
    class func deleteMessageItem(_ message: PFObject) {
        message.deleteInBackground{
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print ("Message has been deleted.")
                
            } else {
                print ("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    class func updateMessageCounter(groupId: String, lastMessage: String) {
        let query = PFQuery(className: "Message")
        query.whereKey("groupId", equalTo: groupId)
        query.limit = 100
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for message in objects as [PFObject]! {
                    let user = message["user2"] as! PFUser
                    if user.objectId != PFUser.current()!.objectId {
                        message.incrementKey("counter") // Increment by 1
                        //message["lastUser"] = PFUser.current()
                        message["lastMessage"] = lastMessage
                        message["updatedAt"] = NSDate()
                        message.saveInBackground{
                            (success: Bool, error: Error?) -> Void in
                            if (success) {
                                // The object has been saved.
                                print ("Message has been updaed.")
                                
                            } else {
                                print ("Error: \(String(describing: error?.localizedDescription))")
                            }
                        }
                    }
                }
            }
        }
    }
    
    class func clearMessageCounter(groupId: String) {
        let query = PFQuery(className: "Message")
        query.whereKey("groupId", equalTo: groupId)
        query.whereKey("user1", equalTo: PFUser.current()!)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for message in objects as [PFObject]! {
                    message["counter"] = 0
                    message.saveInBackground(block: { (succeeded: Bool, error: Error?) -> Void in
                        if error != nil {
                            print("ClearMessageCounter save error.")
                            print("Error: \(String(describing: error?.localizedDescription))")
                        }
                    })
                }
            } else {
                print("ClearMessageCounter save error.")
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
}

