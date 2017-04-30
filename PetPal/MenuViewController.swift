//
//  MenuViewController.swift
//  PetPal
//
//  Created by LING HAO on 4/19/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var WelcomeNavigationController: UIViewController!
    var requestsNavigationController: UIViewController!
    var groupNavigationController: UIViewController!
    var chatNavigationController: UIViewController!
    
    var controllers: [UIViewController] = []
    
    let menuTitle = ["Requests", "Groups", "Chats", "Logout"]
    let logoutRow = 3
    
    weak var hamburgerViewController: HamburgerViewController! {
        didSet {
            view.layoutIfNeeded()
            hamburgerViewController.contentViewController = controllers[1]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        groupNavigationController = storyboard.instantiateViewController(withIdentifier: "GroupNavigationController")
        chatNavigationController = storyboard.instantiateViewController(withIdentifier: "ChatNavigationController")
        
        let requestStoryboard = UIStoryboard(name: "Request", bundle: nil)
        requestsNavigationController = requestStoryboard.instantiateViewController(withIdentifier: "RequestsNavigationController")
        controllers.append(requestsNavigationController)
        controllers.append(groupNavigationController)
        controllers.append(chatNavigationController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitle.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.text = menuTitle[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == logoutRow {
            Utilities.logoutUser()
        } else {
            hamburgerViewController.contentViewController = controllers[indexPath.row]
        }
    }
    
}
