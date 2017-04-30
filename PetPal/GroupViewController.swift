//
//  GroupViewController.swift
//  PetPal
//
//  Created by Rui Mao on 4/29/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse

class GroupViewController: UIViewController, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var groups: [PFObject]! = []
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let query = PFQuery(className: "Group")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?)
            -> Void in
            if error == nil {
                self.groups.removeAll()
                self.groups = objects
               // self.groups.extend(objects as! [PFObject]!)
                self.tableView.reloadData()
            } else {
                //ProgressHUD.showError("Network error")
                print("error: \(error?.localizedDescription)")
            }
            self.refreshControl!.endRefreshing()
        }
    }
    @IBAction func onNewButton(_ sender: UIBarButtonItem) {
        self.actionNew()
    }
    
    func actionNew() {
        let alert = UIAlertView(title: "Please enter a name for your group", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        alert.alertViewStyle = UIAlertViewStyle.plainTextInput
        alert.show()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) 
        let group = self.groups[indexPath.row]
        cell.textLabel?.text = group["name"] as? String
        let query = PFQuery(className: "Message")
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

}
