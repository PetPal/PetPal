//
//  EditRequestViewController.swift
//  PetPal
//
//  Created by LING HAO on 5/5/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class EditRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var actionButton: UIButton!
    
    var request: Request!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // initialize
        switch request.category {
        case .pendingRequest:
            actionButton.isHidden = true
        case .acceptedRequest:
            actionButton.isHidden = false
            actionButton.setTitle("Chat", for: .normal)
        case .task:
            actionButton.isHidden = false
            actionButton.setTitle("Chat", for: .normal)
        case .groupRequest:
            actionButton.isHidden = false
            actionButton.setTitle("Accept", for: .normal)
        }

        let nibName = UINib(nibName: "DateRangeTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "DateRangeTableViewCell")
        
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            switch request.category {
            case .pendingRequest:
                return request.groups?.count ?? 0
            case .acceptedRequest, .task, .groupRequest:
                return 1
            }
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "DateRangeTableViewCell", for: indexPath) as! DateRangeTableViewCell
            dateCell.selectionStyle = .none
            let startDate = request?.startDate
            let endDate = request?.endDate
            dateCell.dateRange = DateRange(startDate: startDate, endDate: endDate)
            return dateCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            
            switch request.category {
            case .pendingRequest:
                cell.textLabel?.text = request.groups![indexPath.row].name
            case .acceptedRequest:
                let user = request.acceptUser
                cell.textLabel?.text = user?.name
            case .task:
                let user = request.requestUser
                cell.textLabel?.text = user?.name
            case .groupRequest:
                let user = request.requestUser
                cell.textLabel?.text = user?.name
            }

            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.textLabel?.text = request.getTypeString()
            return cell
        default:
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            return dateCell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderTableViewCell
        switch section {
        case 0:
            cell.header = request.getCategoryString()
        case 1:
            switch request.category {
            case .pendingRequest:
                cell.header = "Groups"
            case .acceptedRequest:
                cell.header = "Accepted by"
            case .task:
                cell.header = "Task for"
            case .groupRequest:
                cell.header = "Request from"
            }
        case 2:
            cell.header = "Type"
        default:
            cell.header = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    @IBAction func onActionButton(_ sender: Any) {
        switch request.category {
        case .pendingRequest:
            break
        case .acceptedRequest:
            // segue chat
            break
        case .task:
          // segue chat
            break
        case .groupRequest:
            request.acceptUser = User.currentUser
            PetPalAPIClient.sharedInstance.updateRequest(request: request)
            
            _ = navigationController?.popViewController(animated: true)
            break
        }

    }

}
