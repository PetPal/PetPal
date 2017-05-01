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


class AddRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MultiSelectViewControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    let sectionTitles = ["Send Request To", "What, When & Who"]
    
    let groupSection = 0
    let groupTitle = "Select Group"
    //let groups = ["Main St. Small Dogs", "Chihuahua Club", "Lots of Cats"]
    var groups = [String]()
    var selectedGroups: [Bool] = []
    
    let wwwSection = 1
    let wwwTitles = ["Select Service", "Select Dates", "Select Pet"]
    // TODO services are single select
    let services = ["Boarding", "Drop in Visit"]
    var selectedService: [Bool] = []
    let pets = ["Fluffy", "Turtle"]
    var selectedPets: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        let user = User.currentUser
        if let userGroups = user?.groups {
            for group in userGroups {
                groups.append(group.name!)
            }
        }
        
        selectedGroups = Array(repeating: false, count: groups.count)
        selectedService = Array(repeating: false, count: services.count)
        selectedPets = Array(repeating: false, count: pets.count)
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
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MultiSelectCell", for: indexPath)
            cell.textLabel?.text = multiSelectText(emptyText: groupTitle, options: groups, selections: selectedGroups)
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MultiSelectCell", for: indexPath)
                let titleText = wwwTitles[indexPath.row]
                cell.textLabel?.text = multiSelectText(emptyText: titleText, options: services, selections: selectedService)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MultiSelectCell", for: indexPath)
                let titleText = wwwTitles[indexPath.row]
                cell.textLabel?.text = titleText
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MultiSelectCell", for: indexPath)
                let titleText = wwwTitles[indexPath.row]
                cell.textLabel?.text = multiSelectText(emptyText: titleText, options: pets, selections: selectedPets)
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MultiSelectCell", for: indexPath)
                let titleText = wwwTitles[indexPath.row]
                cell.textLabel?.text = titleText
                return cell
                
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MultiSelectCell", for: indexPath)
            return cell
        }
    }
    
    func multiSelectText(emptyText: String, options: [String], selections: [Bool]) -> String {
        var selectText = ""
        for i in 0..<options.count {
            if selections[i] {
                if !selectText.isEmpty {
                    selectText += ", "
                }
                selectText += options[i]
            }
        }
        return selectText.isEmpty ? emptyText : selectText
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    // MARK: - MultiSelectViewControllerDelegate
    
    func multiSelect(multiSelectViewController: MultiSelectViewController, selection: [Bool]) {
        if let indexPath = tableView.indexPathForSelectedRow {
            switch indexPath.section {
            case 1:
                if indexPath.row == 0 {
                    selectedService = selection
                } else {
                    selectedPets = selection
                }
            default:
                selectedGroups = selection
            }
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MultiSelectSegue" {
            let multiSelectVC = segue.destination as! MultiSelectViewController
            multiSelectVC.delegate = self
            if let indexPath = tableView.indexPathForSelectedRow {
                switch indexPath.section {
                case 1:
                    if indexPath.row == 0 {
                        multiSelectVC.selections = services
                        multiSelectVC.selected = selectedService
                    } else {
                        multiSelectVC.selections = pets
                        multiSelectVC.selected = selectedPets
                    }
                default:
                    multiSelectVC.selections = groups
                    multiSelectVC.selected = selectedGroups
                }
            }
        }
    }

    @IBAction func onAddRequestButton(_ sender: Any) {
        let user = User.currentUser
        let today = Date()
        let tomorrow = Date(timeInterval: 60*60*24, since: today)
        var requestType = RequestType.boardingType
        if selectedService[1] {
            requestType = RequestType.dropInVisitType
        }
        // TODO find the selectedGroups 
        let request = Request(requestUser: user!, startDate: today, endDate: tomorrow, requestType: requestType, groups: user!.groups)
        PetPalAPIClient.sharedInstance.addRequest(request: request)
        
        _ = navigationController?.popViewController(animated: true)

    }
}
