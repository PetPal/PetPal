
//
//  ChatViewController.swift
//  PetPal
//
//  Created by Rui Mao on 4/26/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse



class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    var messages = [PFObject]()
    //var messages = NSArray()
    var groupId: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        
    
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSendButton(_ sender: UIButton) {
        let message = PFObject(className:"Message")
        message["username"] = PFUser.current()?.object(forKey: "username")
        message["text"] = messageTextView.text

        message.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print ("Message has been saved.")
                self.onTimer()
                self.tableView.reloadData()
            } else {
                print ("Error: \(error?.localizedDescription)")
            }
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        let message = messages[indexPath.row]
        //cell.textLabel?.text = message["text"] as? String
                cell.textLabel?.text = message.object(forKey: "text") as! String?
        
        return cell
    }
    
    func onTimer() {
        let query = PFQuery(className:"Message")
        //query.whereKey("groupId", equalTo: "84JWUZIAZe")
        query.whereKeyExists("text")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) messages.")
                if let objects = objects {
                    for object in objects {
                      print(object.objectId ?? "Default Message")
                      self.messages.append(object)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error:  \(error?.localizedDescription)")
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

}
