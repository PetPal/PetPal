//
//  RequestsViewController.swift
//  PetPal
//
//  Created by LING HAO on 4/26/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class RequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var requests: [Request]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        let user = User.currentUser
        print("/(user.groups)")
        /*
        PetPalAPIClient.sharedInstance.getGroups(success: { (groups: [Group]) in
            print("got groups")
            for group in groups {
                PetPalAPIClient.sharedInstance.addGroupToUser(user: user!, group: group)
            }
        }) { (error: Error?) in
            print("no groups")
        }
        */
        
        PetPalAPIClient.sharedInstance.getRequests(user: user!, success: { (requests: [Request]) in
            self.requests = requests
            self.tableView.reloadData()
        }) { (error: Error?) in
            print("error \(String(describing: error?.localizedDescription))")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestDetailCell", for: indexPath) as! RequestDetailTableViewCell
        if let request = requests?[indexPath.row] {
            cell.request = request
        }
        return cell
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
