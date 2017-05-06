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
    
    var requestArray: [[Request]] = [ [Request](), [Request](), [Request]() ]
    let requestsIndex = 0
    let tasksIndex = 1
    let groupRequestsIndex = 2
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(forName: PetPalConstants.requestAdded, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            print("request added")
            let request = notification.object as! Request
            
            let index = self.getRequestIndex(request: request)
            self.requestArray[index].append(request)
            if index == self.currentIndex {
                self.tableView.reloadData()
            }
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
    
    func getRequestIndex(request: Request) -> Int {
        switch request.category {
        case RequestCategory.pendingRequest, RequestCategory.acceptedRequest:
            return requestsIndex
        case RequestCategory.task:
            return tasksIndex
        case RequestCategory.groupRequest:
            return groupRequestsIndex
        }
    }
    
    func getRequestArray() -> [Request] {
        return requestArray[currentIndex]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRequestArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestDetailCell", for: indexPath) as! RequestDetailTableViewCell
        let requests = getRequestArray()
        cell.request = requests[indexPath.row]
        return cell
    }
    
    // MARK: Refresh

    @IBAction func onSegmentChanged(_ sender: Any) {
        let control = sender as! UISegmentedControl
        currentIndex = control.selectedSegmentIndex
        tableView.reloadData()
    }
    
    // MARK: Refresh
    
    func refreshControlAction(_ refreshControl: UIRefreshControl? = nil) {
        let user = User.currentUser
        PetPalAPIClient.sharedInstance.getRequestInUserGroup(user: user!, success: { (requests: [Request]) in
            self.populateRequests(requests: requests)
            self.tableView.reloadData()
            
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
        }) { (error: Error?) in
            print("error \(String(describing: error?.localizedDescription))")
        }
    }
    
    func populateRequests(requests: [Request]) {
        for request in requests {
            switch request.category {
            case RequestCategory.pendingRequest, RequestCategory.acceptedRequest:
                requestArray[requestsIndex].append(request)
            case RequestCategory.task:
                requestArray[tasksIndex].append(request)
            case RequestCategory.groupRequest:
                requestArray[groupRequestsIndex].append(request)
            }
        }
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditRequestSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let editRequestVC = segue.destination as! EditRequestViewController
                let requests = getRequestArray()
                editRequestVC.request = requests[indexPath.row]
            }
        }
    }

}
