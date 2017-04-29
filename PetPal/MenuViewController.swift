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
    
    var loginNavigationController: UIViewController!
    var requestsNavigationController: UIViewController!
    
    var controllers: [UIViewController] = []
    
    let menuTitle = ["Login", "Requests"]
    
    weak var hamburgerViewController: HamburgerViewController! {
        didSet {
            view.layoutIfNeeded()
            hamburgerViewController.contentViewController = controllers[0]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        loginNavigationController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
        
        let requestStoryboard = UIStoryboard(name: "Request", bundle: nil)
        requestsNavigationController = requestStoryboard.instantiateViewController(withIdentifier: "RequestsNavigationController")
        
        controllers.append(loginNavigationController)
        controllers.append(requestsNavigationController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllers.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.text = menuTitle[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hamburgerViewController.contentViewController = controllers[indexPath.row]
    }
    
}
