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
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        groupCreatedAtDate.text = "Created at " + formatter.string(from: group.timeStamp!)
        if let file = group.profileImage {
            groupImage.file = file
            groupImage.loadInBackground()
            groupBackgroundImage.file = file
            groupBackgroundImage.loadInBackground()
        }
        
        if let objectId = group.pfObject?.objectId {
            if User.currentUser?.getGroup(fromId: objectId) != nil {
                myGroup = true
            }
        }
        
        groupActionButton.titleLabel?.text = myGroup ? "Ask For Help" : "Join Group"
        
        PetPalAPIClient.sharedInstance.getUsers(group: group, success: { (users: [User]) in
            print(users)
            self.users = users
            self.tableView.reloadData()
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
        // TODO custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupUserCell", for: indexPath)
        cell.textLabel?.text = users?[indexPath.row].name
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addRequestSegue" {
            let addRequestVC = segue.destination as! AddRequestViewController
            addRequestVC.initialSelectedGroup = group
        }
    }
    
    @IBAction func onGroupActionButton(_ sender: UIButton) {
        if myGroup {
            performSegue(withIdentifier: "addRequestSegue", sender: self)
        } else {
            print("TODO join group")
        }
    }

}
