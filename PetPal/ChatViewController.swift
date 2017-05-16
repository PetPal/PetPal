
//
//  ChatViewController.swift
//  PetPal
//
//  Created by Rui Mao on 4/26/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import JSQMessagesViewController
import Foundation
import MediaPlayer


class ChatViewController: JSQMessagesViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var timer: Timer = Timer()
    var isLoading: Bool = false
    
    var groupId: String = ""
    
    var users = [PFUser]()
    var messages = [JSQMessage]()
    var avatars = Dictionary<String, JSQMessagesAvatarImage>()
    
    var bubbleFactory = JSQMessagesBubbleImageFactory()
    var outgoingBubbleImage: JSQMessagesBubbleImage!
    var incomingBubbleImage: JSQMessagesBubbleImage!
    
    var blankAvatarImage: JSQMessagesAvatarImage!
    
    var senderImageUrl: String!
    var batchMessages = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 57/256, green: 127/256, blue: 204/256, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        if let user = PFUser.current() {
            self.senderId = user.objectId
            self.senderDisplayName = user["name"] as! String
        }
        
        outgoingBubbleImage = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        incomingBubbleImage = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        
        blankAvatarImage = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "defaultProfileImage"), diameter: 30)
        
        isLoading = false
        self.loadMessages()
        Messages.clearMessageCounter(groupId: groupId);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.collectionViewLayout.springinessEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ChatViewController.loadMessages), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    // Mark: - Backend methods
    
    func loadMessages() {
        if self.isLoading == false {
            self.isLoading = true
            let lastMessage = messages.last
            
            let query = PFQuery(className: "Chat")
            query.whereKey("groupId", equalTo: groupId)
            if let lastMessage = lastMessage {
                query.whereKey("createdAt", greaterThan: lastMessage.date)
            }
            query.includeKey("user")
            query.order(byDescending: "createdAt")
            query.limit = 50
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) -> Void in
                if error == nil {
                    self.automaticallyScrollsToMostRecentMessage = false
                    for object in (objects as [PFObject]!).reversed() {
                        self.addMessage(object)
                    }
                    if objects!.count > 0 {
                        self.finishReceivingMessage()
                        self.scrollToBottom(animated: false)
                    }
                    self.automaticallyScrollsToMostRecentMessage = true
                } else {
                    let alertController = UIAlertController(title: "Network Error", message: "", preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true)
                    print ("Error: \(String(describing: error?.localizedDescription))")                }
                self.isLoading = false;
            })
        }
    }
    
    func addMessage(_ object: PFObject) {
        let message: JSQMessage!
        let user = object["user"] as! PFUser
        let name = user["name"] as! String
        
         message = JSQMessage(senderId: user.objectId, senderDisplayName: name, date: object.createdAt, text: (object["text"] as? String))
        users.append(user)
        messages.append(message)
    }
    
    func sendMessage(_ text: String, video: URL?, picture: UIImage?) {
        let text = text
        let object = PFObject(className: "Chat")
        object["user"] = PFUser.current()
        object["groupId"] = self.groupId
        object["text"] = text
        object.saveInBackground{ (succeeded: Bool, error: Error?) -> Void in
            if error == nil {
                //JSQSystemSoundPlayer.jsq_playMessageSentSound()
                //self.loadMessages()
            } else {
                let alertController = UIAlertController(title: "Network Error", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                print ("Error: \(String(describing: error?.localizedDescription))")
            }
        }
        
      //  PushNotication.sendPushNotification(groupId, text: text)
        Messages.updateMessageCounter(groupId: groupId, lastMessage: text)
        
        self.finishSendingMessage()
    }
    
    // MARK: - JSQMessagesViewController method overrides
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        self.sendMessage(text, video: nil, picture: nil)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        self.view.endEditing(true)
        let action = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take photo", "Choose existing photo")
        action.show(in: self.view)
    }
    
    // MARK: - JSQMessages CollectionView DataSource
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages[indexPath.row]
        if message.senderId == self.senderId {
            return outgoingBubbleImage
        }
        return incomingBubbleImage
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
       /* let user = self.users[indexPath.row]
        if self.avatars[user.objectId!] == nil {
            let thumbnailFile = user["userAvatar"] as? PFFile
            thumbnailFile?.getDataInBackground(block: { (imageData: Data?, error: Error?) -> Void in
                if error == nil {
                    self.avatars[user.objectId!] = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(data: imageData!), diameter: 30)
                    self.collectionView.reloadData()
                }
            })
            return blankAvatarImage
        } else {
            return self.avatars[user.objectId!]
        }*/
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            let message = self.messages[indexPath.row]
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        return nil;
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = self.messages[indexPath.row]
        if message.senderId == self.senderId {
            return nil
        }else {
            let messageUsername = message.senderDisplayName
            return NSAttributedString(string: messageUsername!)
        }
        
        if indexPath.item > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == message.senderId {
                return nil
            }
        }
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        return nil
    }
    
    // MARK: - UICollectionView DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    // MARK: - UICollectionView flow layout
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if indexPath.row % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 15
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        let message = self.messages[indexPath.item]
        if message.senderId == self.senderId {
            return 0
        }
        
        if indexPath.item > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == message.senderId {
                return 0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAt indexPath: IndexPath!) -> CGFloat {
        return 0
    }
        
    
    
    // MARK: - UIActionSheetDelegate
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = false
        if buttonIndex != actionSheet.cancelButtonIndex {
            if buttonIndex == 1 {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("Camera is available 📸")
                    vc.sourceType = .camera
                } else {
                    print("Camera 🚫 available so we will use photo library instead")
                    vc.sourceType = .photoLibrary
                }
            } else if buttonIndex == 2 {
                vc.sourceType = .photoLibrary
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [AnyHashable: Any]) {
        let video = info[UIImagePickerControllerMediaURL] as? URL
        let picture = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.sendMessage("", video: video, picture: picture)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onCancelButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
