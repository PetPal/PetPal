//
//  GroupDetailViewController.swift
//  PetPal
//
//  Created by LING HAO on 5/10/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import ParseUI

class GroupDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var groupBackgroundImage: PFImageView!
    @IBOutlet var groupImage: PFImageView!
    @IBOutlet var groupName: UILabel!
    @IBOutlet var groupCreatedAtDate: UILabel!
    @IBOutlet var groupDescription: UILabel!
    @IBOutlet var groupActionButton: UIButton!
    
    @IBOutlet var tableView: UITableView!
    
    var group: Group!
    var myGroup: Bool = false
    
    var users: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        groupName.text = group.name
        groupDescription.text = group.overview
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        groupCreatedAtDate.text = "Together since " + formatter.string(from: group.timeStamp!)
        if let file = group.profileImage {
            groupImage.file = file
            groupImage.loadInBackground()
            groupBackgroundImage.file = file
            groupBackgroundImage.loadInBackground()
        }
        
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension

        if let objectId = group.pfObject?.objectId {
            if User.currentUser?.getGroup(fromId: objectId) != nil {
                myGroup = true
            }
        }
        
        groupActionButton.setTitle(myGroup ? "Ask For Help" : "Join Group", for: .normal)
        
        PetPalAPIClient.sharedInstance.getUsers(group: group, success: { (users: [User]) in
            self.users = users
            self.tableView.reloadData()
        }) { (error: Error?) in
        }
        
        NotificationCenter.default.addObserver(forName: PetPalConstants.userGroupUpdated, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.updateData()
        }
    }
    
    func updateData() {
        groupActionButton.setTitle(myGroup ? "Ask For Help" : "Join Group", for: .normal)

        PetPalAPIClient.sharedInstance.getUsers(group: group, success: { (users: [User]) in
            self.users = users
            // animate
            if let row = users.index(of: User.currentUser!) {
                let indexPath = IndexPath(row: row, section: 0)
                self.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.middle)
            }
        }) { (error: Error?) in
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupUserCell", for: indexPath) as! GroupUserTableViewCell
        cell.selectionStyle = .none
        cell.user = users?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupHeaderTableViewCell") as! GroupHeaderTableViewCell
        cell.header = /*String(users?.count ?? 0) + */ " Group Members"
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRequestSegue" {
            let addRequestVC = segue.destination as! AddRequestViewController
            addRequestVC.initialSelectedGroup = group
        } else if segue.identifier == "showProfileSegue" {
            let profileVC = segue.destination as! ProfileViewController
            let indexPath = tableView.indexPath(for: sender as! GroupUserTableViewCell)
            profileVC.user = users?[(indexPath?.row)!]
        }
    }
    
    @IBAction func onGroupActionButton(_ sender: UIButton) {
        if myGroup {
            // ask for help
            performSegue(withIdentifier: "addRequestSegue", sender: self)
        } else {
            // join group
            if let user = User.currentUser {
                myGroup = true
                PetPalAPIClient.sharedInstance.addGroupToUser(user: user, group: group)
            }
            // Stay on this page to allow user to ask for help
            //self.navigationController?.popViewController(animated: true)
        }
    }

}
