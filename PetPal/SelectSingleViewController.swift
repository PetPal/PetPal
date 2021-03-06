//
//  SelectSingleViewController.swift
//  PetPal
//
//  Created by Rui Mao on 5/12/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse

protocol SelectSingleViewControllerDelegate {
    func didSelectSingleUser(_ user: PFUser)
}


class SelectSingleViewController: UITableViewController, UISearchBarDelegate {
    
    var users = [PFUser]()
    var delegate: SelectSingleViewControllerDelegate!
    
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 57/256, green: 127/256, blue: 204/256, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white

        
        // register tableView Cell
        let nibName = UINib(nibName: "GroupCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "GroupCell")
        
        self.searchBar.delegate = self
        self.loadUsers()
    }
    @IBAction func onCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Backend methods
    
    func loadUsers() {
        let user = PFUser.current()
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", notEqualTo: user!.objectId!)
        
        query.order(byAscending: "name")
        query.limit = 50
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                self.users.removeAll(keepingCapacity: false)
                self.users = objects as! [PFUser]
                    self.tableView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Network Error", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                print ("Error: \(String(describing: error?.localizedDescription))")
            }
            
        }
    }
    
    func searchUsers(_ searchText: String) {
        let user = PFUser.current()
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", notEqualTo: user!.objectId!)
        
        query.whereKey("name", matchesRegex: "(?i) (searchText)")
        //query.whereKey("name", matchesRegex: "(?i)\(String(describing: searchBar.text))")
        query.order(byAscending: "name")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                self.users.removeAll(keepingCapacity: false)
                
                self.users = objects as! [PFUser]
                
              //  self.users += objects as! [PFUser]!
                self.tableView.reloadData()
            } else {
                let alertController = UIAlertController(title: "Network Error", message: "", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                print ("Error: \(String(describing: error?.localizedDescription))")
            }
            
        }
    }
    
    // MARK: - User actions
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupCell
        
        let user = self.users[indexPath.row]
        
        cell.groupAvatar.file = user["userAvatar"] as? PFFile
        cell.groupAvatar.loadInBackground()
        cell.nameLabel.text = user["name"] as? String
        cell.createdAtLabel.text = ""
        cell.groupOverview.text = ""

        
       // cell.textLabel?.text = user["name"] as? String
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: { () -> Void in
            if self.delegate != nil {
                self.delegate.didSelectSingleUser(self.users[indexPath.row])
            }
        })
    }
    
    // MARK: - UISearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.loadUsers()
        } else {
            self.searchUsers(searchText.lowercased())
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarCancelled()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelled() {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        
        self.loadUsers()
    }
}

