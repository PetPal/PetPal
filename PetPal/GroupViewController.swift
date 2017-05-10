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
        self.refreshControl!.addTarget(self, action: #selector(loadGroups), for: UIControlEvents.valueChanged)
        
        NotificationCenter.default.addObserver(forName: PetPalConstants.userGroupUpdated, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.loadGroups()
        }
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
        let user = User.currentUser
        groups = user?.groups
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        let group = self.groups[indexPath.row]
        cell.nameLabel.text = group.name
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        cell.createdAtLabel?.text = "Created at: " + formatter.string(from: group.timeStamp!)
        cell.createdAtLabel?.textColor = UIColor.lightGray
        let file = group.profileImage
        cell.groupAvatar.file = file
        cell.groupAvatar.loadInBackground()
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "groupDetailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let detailGroupVC = segue.destination as! GroupDetailViewController
                detailGroupVC.group = groups[indexPath.row]
            }
        }
    }

    
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
    
    
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ChatViewController {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let group = groups[indexPath!.row]
            //let groupId = group.objectId! as String
            let chatViewController = segue.destination as! ChatViewController
            //chatViewController.groupId = groupId
        }
    }
 */
    

}
