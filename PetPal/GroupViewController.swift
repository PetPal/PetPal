//
//  GroupViewController.swift
//  PetPal
//
//  Created by Rui Mao on 4/29/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse

class GroupViewController: UIViewController, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    
    var groups: [Group]! = []
    var refreshControl: UIRefreshControl!
    var groupNameField: UITextField?
    var groupTypeField: UITextField?
   
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //set Nav bar color
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 157/256, green: 169/256, blue: 61/256, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        // Pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: #selector(GroupViewController.loadGroups), for: UIControlEvents.valueChanged)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.current() != nil {
            self.loadGroups()
        } else {
            Utilities.loginUser(self)
        }
    }
    
    func loadGroups() {
        //fetching the group which the current user belongs to
        let user = User.currentUser
        self.groups.removeAll()
        PetPalAPIClient.sharedInstance.populateGroups(forUser: user!)
        self.groups = user?.groups
        self.tableView.reloadData()
        }
       /* let query = PFQuery(className: "Group")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?)
            -> Void in
            if error == nil {
                self.groups.removeAll()
                self.groups = objects
               // self.groups.extend(objects as! [PFObject]!)
                self.tableView.reloadData()
            } else {
                print("error: \(error?.localizedDescription)")
            }
            self.refreshControl!.endRefreshing()
        }*/
    
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        let group = self.groups[indexPath.row]
        cell.textLabel?.text = group.name
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        cell.detailTextLabel?.text = "Created at: " + formatter.string(from: group.timeStamp!)
        cell.detailTextLabel?.textColor = UIColor.lightGray
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    /*func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupChatSegue" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as! String
            //if let indexPath = tableView.indexPathForSelectedRow
            //let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            chatVC.groupId = groupId as String
            
        }
    }
 */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ChatViewController {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let group = groups[indexPath!.row]
            //let groupId = group.objectId! as String
            let chatViewController = segue.destination as! ChatViewController
            //chatViewController.groupId = groupId
        }
    }
    

}
