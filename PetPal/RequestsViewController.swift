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
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.barTintColor = UIColor(colorLiteralRed: 224/256, green: 142/256, blue: 67/256, alpha: 1.0)
        navigationBarAppearance.isTranslucent = false


        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(forName: PetPalConstants.requestAdded, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            print("request added")
            let request = notification.object as! Request
            self.requests?.append(request)
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: PetPalConstants.userGroupUpdated, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            print("request - user group updated")
            self.refreshControlAction()
        }

        
        // pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)

        // update requests
        refreshControlAction()
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
    
    // MARK: Refresh
    
    func refreshControlAction(_ refreshControl: UIRefreshControl? = nil) {
        let user = User.currentUser
        PetPalAPIClient.sharedInstance.getRequestInUserGroup(user: user!, success: { (requests: [Request]) in
            self.requests = requests
            self.tableView.reloadData()
            
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
        }) { (error: Error?) in
            print("error \(String(describing: error?.localizedDescription))")
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
