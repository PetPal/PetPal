//
//  MultiSelectViewController.swift
//  PetPal
//
//  Created by LING HAO on 4/27/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

@objc protocol MultiSelectViewControllerDelegate: class {
    @objc optional func multiSelect(multiSelectViewController: MultiSelectViewController, selection: [Bool])
}

class MultiSelectViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    weak var delegate: MultiSelectViewControllerDelegate?
    
    var selected: [Bool]?
    var selections: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - tableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = selections?[indexPath.row]
        if selected![indexPath.row] {
            cell.imageView?.image = UIImage(named: "checked_checkbox")
        } else {
            cell.imageView?.image = UIImage(named: "unchecked_checkbox")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let select = selected![indexPath.row]
        selected![indexPath.row] = !select
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    // MARK: - Navigation

    @IBAction func onSelectButton(_ sender: Any) {
        delegate?.multiSelect?(multiSelectViewController: self, selection: selected!)
        
        _ = navigationController?.popViewController(animated: true)
    }
}
