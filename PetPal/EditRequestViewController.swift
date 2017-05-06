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
    
    var request: Request!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

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
            return request.groups?.count ?? 0
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
            cell.textLabel?.text = request.groups![indexPath.row].name
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
            cell.header = "Dates"
        case 1:
            cell.header = "Groups"
        case 2:
            cell.header = "Type"
        default:
            cell.header = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Dates"
        case 1:
            return "Groups"
        case 2:
            return "Type"
        default:
            return ""
        }
    }
 */

}
