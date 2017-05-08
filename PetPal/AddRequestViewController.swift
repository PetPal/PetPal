//
//  AddRequestViewController.swift
//  PetPal
//
//  Created by LING HAO on 4/27/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

@objc protocol AddRequestViewControllerDelegate: class {
    @objc optional func multiSelect(addRequestViewController: AddRequestViewController, request: Request)
}


class AddRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DateSelectViewControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    let sectionTitles = ["Date", "Groups", "Type"]
    
    var groups: [Group]?
    var selectedGroups: [Bool] = []
    
    // TODO services
    let services = ["Boarding", "Drop in Visit"]
    var selectedService: [Bool] = []
    
    var startDate: Date?
    var endDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        let user = User.currentUser
        groups = user?.groups
        
        if let groups = groups {
            if groups.count > 0 {
                selectedGroups = Array.init(repeating: true, count: groups.count)
            }
        }
        
        let nibName = UINib(nibName: "DateRangeTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "DateRangeTableViewCell")
        
        let basicNibName = UINib(nibName: "BasicTableViewCell", bundle: nil)
        tableView.register(basicNibName, forCellReuseIdentifier: "BasicTableViewCell")
        
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return groups?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let startDate = startDate, let endDate = endDate {
                let dateCell = tableView.dequeueReusableCell(withIdentifier: "DateRangeTableViewCell", for: indexPath) as! DateRangeTableViewCell
                dateCell.selectionStyle = .none
                let startDate = startDate
                let endDate = endDate
                dateCell.dateRange = DateRange(startDate: startDate, endDate: endDate)
                return dateCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BasicTableViewCell", for: indexPath) as! BasicTableViewCell
                cell.selectionStyle = .none
                cell.basicText = "Select dates"
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicTableViewCell", for: indexPath) as! BasicTableViewCell
            cell.selectionStyle = .none
            cell.group = groups?[indexPath.row]
            cell.checkSelected = selectedGroups[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicTableViewCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderTableViewCell
        cell.header = sectionTitles[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "DateSelectSegue", sender: self)
        } else if indexPath.section == 1 {
            let selected = selectedGroups[indexPath.row]
            selectedGroups[indexPath.row] = !selected
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    // MARK: - DateSelectViewControllerDelegate
    
    func dateSelected(dateSelectViewController: DateSelectViewController, startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DateSelectSegue" {
            let dateSelectVC = segue.destination as! DateSelectViewController
            dateSelectVC.delegate = self
            
        }
    }
    
    // MARK: - Actions

    @IBAction func onAddRequestButton(_ sender: Any) {
        // TODO error recovery? alert dialog?
        guard let startDate = startDate, let endDate = endDate else { return }
        
        let user = User.currentUser
        var requestType = RequestType.boardingType
        //requestType = RequestType.dropInVisitType
        
        // gather the selectedGroups
        var requestGroups = [Group]()
        if let userGroups = user?.groups {
            for i in 0..<selectedGroups.count {
                if selectedGroups[i] {
                    requestGroups.append(userGroups[i])
                }
            }
        }

        let request = Request(requestUser: user!, startDate: startDate, endDate: endDate, requestType: requestType, groups: requestGroups)
        PetPalAPIClient.sharedInstance.addRequest(request: request)
        
        _ = navigationController?.popViewController(animated: true)

    }
}
