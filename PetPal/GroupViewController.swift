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
    var endpoint : String = "mygroups"
    
    
    @IBOutlet weak var tabbar: UITabBar!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 157/256, green: 169/256, blue: 61/256, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
     /*for storyboardID in self.storyboardIDs {
            let controller = (self.storyboard?.instantiateViewController(withIdentifier: storyboardID))! as! GroupViewController
            viewControllers.append(controller)
        }*/
       /*  window = UIWindow(frame: UIScreen.main.bounds)
        //self.tabbar.delegate = self
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mygroupsNavigationController = storyboard.instantiateViewController(withIdentifier: "GroupNavigationController") as! UINavigationController
        let mygroupsViewController = mygroupsNavigationController.topViewController as! GroupViewController
        mygroupsViewController.endpoint = "mygroups"
        mygroupsNavigationController.tabBarItem.title = "My groups"
        //mygroupsNavigationController.tabBarItem.image = UIImage(named: "now_playing")
        
        let nearbygroupsNavigationController = storyboard.instantiateViewController(withIdentifier: "GroupNavigationController") as! UINavigationController
        let nearbygroupsViewController = nearbygroupsNavigationController.topViewController as! GroupViewController
        nearbygroupsViewController.endpoint = "nearbygroups"
        nearbygroupsNavigationController.tabBarItem.title = "Nearby Groups"
        //nearbygroupsNavigationController.tabBarItem.image = UIImage(named: "top_rated")
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mygroupsNavigationController, nearbygroupsNavigationController]
         
         window?.rootViewController = tabBarController
         window?.makeKeyAndVisible()
 */

        //

        // Do any additional setup after loading the view.
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
        
        switch self.endpoint {
            case "mygroups":
                
                let user = User.currentUser
            //fetching the group which the current user belongs to
                self.groups.removeAll()
                PetPalAPIClient.sharedInstance.populateGroups(forUser: user!)
                self.groups = user?.groups
            self.tableView.reloadData()
            case "nearbygroups":
                //fetching the groups within 20mil of the current user's zipcode
                self.groups = User.currentUser?.groups
            
        default :
            return
            
            
    
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
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
        
        //return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        let group = self.groups[indexPath.row]
        
        cell.textLabel?.text = group.name
        /*let query = PFQuery(className: "Message")
        query.whereKey("groupId", equalTo: group.objectId ?? 0)
        query.order(byDescending: "createdAt")
        query.limit = 1000
        query.findObjectsInBackground { (objects: [PFObject]?, error:Error?) in
            if let chat = objects!.first as PFObject! {
            let date = NSDate()
            let seconds = date.timeIntervalSince(chat.createdAt!)
            let elapsed = Utilities.timeElapsed(seconds);
            let countString = (objects!.count > 1) ? "\(objects!.count) messages" : "\(objects!.count) message"
            cell.detailTextLabel?.text = "\(countString) \(elapsed)"
        } else {
            cell.detailTextLabel?.text = "0 messages"
        }
        cell.detailTextLabel?.textColor = UIColor.lightGray
        }
        */
    
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
    
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let group = self.groups[indexPath.row]
        let groupId = group.objectId! as String
        
        //Messages.createMessageItem(PFUser.currentUser()!, groupId: groupId, description: group[PF_GROUPS_NAME] as! String)
        
        self.performSegue(withIdentifier: "groupChatSegue", sender: groupId)
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
