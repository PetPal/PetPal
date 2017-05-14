//
//  MessagesViewController.swift
//  PetPal
//
//  Created by Rui Mao on 5/5/17.
//  Copyright © 2017 PetPal. All rights reserved.


import UIKit
import Parse

class MessagesViewController: UITableViewController, SelectSingleViewControllerDelegate  {
    
    var messages = [PFObject]()
    
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet var composeButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0;
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 57/256, green: 127/256, blue: 204/256, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        // NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.cleanup), name: NSNotification.Name(rawValue: NOTIFICATION_USER_LOGGED_OUT), object: nil)
        
        self.loadMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.loadMessages), name: NSNotification.Name(rawValue: "reloadMessages"), object: nil)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(MessagesViewController.loadMessages), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(self.refreshControl!)
        
         self.emptyView?.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.current() != nil {
            self.loadMessages()
        } else {
            Utilities.loginUser(self)
        }
    }
    
    // MARK: - Backend methods
    
    func loadMessages() {
        let query = PFQuery(className: "Message")
        query.whereKey("user", equalTo: PFUser.current()!)
        query.includeKey("lastUser")
        query.order(byDescending: "updatedAt")
        query.findObjectsInBackground{ (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                self.messages.removeAll(keepingCapacity: false)
                self.messages = objects as [PFObject]!
                //DispatchQueue.main.async {
                self.tableView.reloadData()
                //}
                self.updateEmptyView()
                self.updateTabCounter()
            } else {
                print("Network error")
            }
            self.refreshControl!.endRefreshing()
        }
    }
    
    // MARK: - Helper methods
    
    func updateEmptyView() {
        self.emptyView?.isHidden = (self.messages.count != 0)
    }
    
    func updateTabCounter() {
        var total = 0
        for message in self.messages {
            total += message["counter"]! as! Int
        }
        //let item = self.tabBarController!.tabBar.items![1]
       // let item = MenuViewController.
        //item.badgeValue = (total == 0) ? nil : "\(total)"
    }
    
    // MARK: - User actions
    
    func openChat(_ groupId: String) {
        self.performSegue(withIdentifier: "messagesChatSegue", sender: groupId)
    }
    
   
    
    func cleanup() {
        self.messages.removeAll(keepingCapacity: false)
        self.tableView.reloadData()
        self.updateTabCounter()
        self.updateEmptyView()
    }
    
    @IBAction func compose(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "selectSingleSegue", sender: self)

    }
    
    // MARK: - Prepare for segue to chatVC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messagesChatSegue" {
            let chatVC = (segue.destination as! UINavigationController).topViewController as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as! String
            chatVC.groupId = groupId
        } else if segue.identifier == "selectSingleSegue" {
            let selectSingleVC = (segue.destination as! UINavigationController).topViewController as! SelectSingleViewController
            selectSingleVC.delegate = self
        }
    }
    

    
    // MARK: - UIActionSheetDelegate

    
    // MARK: - SelectSingleDelegate
    
    func didSelectSingleUser(_ user2: PFUser) {
        let user1 = PFUser.current()!
        let groupId = Messages.startPrivateChat(user1, user2: user2)
        self.openChat(groupId)
    }
    
    // MARK: - SelectMultipleDelegate
    
   /* func didSelectMultipleUsers(_ selectedUsers: [PFUser]!) {
        let groupId = Messages.startMultipleChat(selectedUsers)
        //self.openChat(groupId)
        self.openChat()
    }
    
    // MARK: - AddressBookDelegate
    
    func didSelectAddressBookUser(_ user2: PFUser) {
        let user1 = PFUser.current()!
        let groupId = Messages.startPrivateChat(user1, user2: user2)
        //self.openChat(groupId)
        self.openChat()
    }
    
    // MARK: - FacebookFriendsDelegate
    
    func didSelectFacebookUser(_ user2: PFUser) {
        let user1 = PFUser.current()!
        let groupId = Messages.startPrivateChat(user1, user2: user2)
        //self.openChat(groupId)
        self.openChat()
    }
 */
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "MessagesCell") as! MessagesCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell", for: indexPath) as! MessagesCell
        let message = self.messages[indexPath.row] as PFObject
        cell.message = message
        
        //cell.bindData(self.messages[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        Messages.deleteMessageItem(self.messages[indexPath.row])
        self.messages.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        self.updateEmptyView()
        self.updateTabCounter()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let message = self.messages[indexPath.row] as PFObject
        self.openChat(message["groupId"] as! String)
        //self.openChat(groupId)
    }
}
