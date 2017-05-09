
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



class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var messages = [PFObject]()
    var groupId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 57/256, green: 127/256, blue: 204/256, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        let timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
        
        timer.fire()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSendButton(_ sender: UIButton) {
        let message = PFObject(className:"Message")
        message["user"] = PFUser.current()
        message["text"] = messageTextView.text

        message.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print ("Message has been saved.")
                self.view.window?.endEditing(true)
                self.messageTextView.text = ""
                self.onTimer()
                self.tableView.reloadData()
            } else {
                print ("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    func queryForTable() -> PFQuery<PFObject>! {
        let query = PFQuery(className: "User")
        query.includeKey("username")
        return query
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        
        let message = messages[indexPath.row]
        cell.messageLabel?.text = message.object(forKey: "text") as! String?
       // cell.avatarImageView.file = user["user"].object(forKey: "userAvatar")as? PFFile
        let user = message.object(forKey: "user") as? PFUser
        cell.avatarImageView.file = nil
        if (user != nil) {
            let file = user?.object(forKey: "userAvatar") as! PFFile
            cell.avatarImageView.file = file
            cell.avatarImageView.loadInBackground()
        }
        return cell
    }
    
    func onTimer() {
        //self.messages.removeAll()
        let query = PFQuery(className:"Message")
        //query.whereKey("groupId", equalTo: groupId)
        query.whereKeyExists("text")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                //print("Successfully retrieved \(objects!.count) messages.")
                if let objects = objects {
                    self.messages = objects
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error:  \(String(describing: error?.localizedDescription))")
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
