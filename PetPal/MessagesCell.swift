//
//  MessagesCell.swift
//  PetPal
//
//  Created by Rui Mao on 5/5/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import JSQMessagesViewController

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var userImage: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    var message: Messages! {
        didSet {
            let lastUser = message.user2
            self.userImage.file = lastUser?.userAvatar
            self.userImage.loadInBackground()
            self.nameLabel.text = lastUser?.name
            self.lastMessageLabel.text = message.lastMessage
            let date = Date()
          
            if let updateDate = message.updatedAt {
                let timeInterval = date.timeIntervalSince(updateDate)
                self.timeElapsedLabel.text = Utilities.timeElapsed(timeInterval)
            }
            if let counter = message.counter {
            counterLabel.text = (counter == 0) ? "" : "\(String(describing: counter)) new"
            }
            
 
           /* let dateText = JSQMessagesTimestampFormatter.shared().relativeDate(for: message["updatedAt"] as? Date)
            if dateText == "Today" {
                timeElapsedLabel.text = JSQMessagesTimestampFormatter.shared().time(for: message["updatedAt"] as? Date)
            } else {
                timeElapsedLabel.text = dateText
            }*/
            
           // let counter = message["counter"] as! Int
           // counterLabel.text = (counter == 0) ? "" : "\(counter) new"

            
        }
    }
    /*func bindData(_ message: PFObject) {
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.layer.masksToBounds = true
        
        let lastUser = message["lastUser"] as? PFUser
        userImage.file = lastUser?["userAvatar"] as? PFFile
        userImage.loadInBackground()
        
        nameLabel.text = lastUser?["name"] as? String
        
       // descriptionLabel.text = message["text"] as? String
        lastMessageLabel.text = message["text"] as? String
        
        
       // let elapseTimeInSeconds = Date().timeIntervalSince(date as Date)
        
       // Strong!!! Date() or NSDate().timeIntervalSince(date as Date)
        let date = Date()
        let timeInterval = date.timeIntervalSince(message["updatedAt"] as! Date)

        //Date().timeIntervalSince(date as Date)
        
        
        timeElapsedLabel.text = Utilities.timeElapsed(timeInterval)
        let dateText = JSQMessagesTimestampFormatter.shared().relativeDate(for: message["updatedAt"] as? Date)
        if dateText == "Today" {
            timeElapsedLabel.text = JSQMessagesTimestampFormatter.shared().time(for: message["updatedAt"] as? Date)
        } else {
            timeElapsedLabel.text = dateText
        }
        
        let counter = message["counter"] as! Int
        counterLabel.text = (counter == 0) ? "" : "\(counter) new"
    }*/
    
}

