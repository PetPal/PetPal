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
    
    class func startPrivateChat(_ user1: PFUser, user2: PFUser) -> String {
        let id1 = user1.objectId
        let id2 = user2.objectId
        
        let groupId = (id1! < id2!) ? "\(id1)\(id2)" : "\(id2)\(id1)"
        
        createMessageItem(user1, groupId: groupId, description: user2["name"] as! String)
        createMessageItem(user2, groupId: groupId, description: user1["name"] as! String)
        
        return groupId
    }
    
    class func startMultipleChat(_ users: [PFUser]!) -> String {
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
    }
    
    class func createMessageItem(_ user: PFUser, groupId: String, description: String) {
        let query = PFQuery(className: "Message")
        query.whereKey("user", equalTo: user)
        query.whereKey("groupId", equalTo: groupId)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                if objects!.count == 0 {
                    let message = PFObject(className: "Message")
                    message["user"] = user;
                    message["groupId"] = groupId;
                    message["text"] = description;
                    message["lastUser"] = PFUser.current()
                    //message[PF_MESSAGES_LASTMESSAGE] = "";
                    //message["counter"] = 0
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
    
    class func updateMessageCounter(_ groupId: String, lastMessage: String) {
        let query = PFQuery(className: "Message")
        query.whereKey(groupId, equalTo: groupId)
        query.limit = 1000
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                for message in objects as [PFObject]! {
                    let user = message["user"] as! PFUser
                    if user.objectId != PFUser.current()!.objectId {
                        message.incrementKey("counter") // Increment by 1
                        message["lastUser"] = PFUser.current()
                        //message[PF_MESSAGES_LASTMESSAGE] = lastMessage
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
    
    class func clearMessageCounter(_ groupId: String) {
        let query = PFQuery(className: "Message")
        query.whereKey("groupId", equalTo: groupId)
        query.whereKey("user", equalTo: PFUser.current()!)
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

