//
//  ProfileViewController.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 4/30/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import ParseUI

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var petCount: UILabel!
    @IBOutlet weak var creditCount: UILabel!
    @IBOutlet weak var groupCount: UILabel!
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var imageBorderView: UIView!
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var addButton: UIButton!
    

    var requests: [Request]?
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        if(user == nil){
         user = User.currentUser
        }
        
        if user != User.currentUser {
            addButtonView.isHidden = true
            addButton.isHidden = true
        }
        
        PetPalAPIClient.sharedInstance.getRequests(user: user!, success: { (requests: [Request]) in
            self.requests = requests
            self.profileTableView.reloadData()
        }) { (error: Error?) in
            print("error \(String(describing: error?.localizedDescription))")
        }
        
        profileTableView.estimatedRowHeight = 320
        profileTableView.rowHeight = UITableViewAutomaticDimension
        
        let nibName = UINib(nibName: "RequestDetailTableViewCell", bundle: nil)
        profileTableView.register(nibName, forCellReuseIdentifier: "RequestDetailCell")
        
        //Updating data on labels
        nameLabel.text = user?.name
        petCount.text = "\(user?.pets?.count ?? 0)"
        groupCount.text = "\(user?.groups?.count ?? 0)"
        
        //Updating the profileImage
        if let avatar = user?.userAvatar {
            profileImage.file = avatar
            profileImage.loadInBackground()
            profileImage.setRounded()
        }
        let radius = imageBorderView.frame.width / 2
        imageBorderView.layer.cornerRadius = radius
        imageBorderView.layer.borderColor = UIColor.darkGray.cgColor
        imageBorderView.layer.borderWidth = 1
        
        
        let addButtonRadius = addButtonView.frame.width / 2
        addButtonView.layer.cornerRadius = addButtonRadius
        addButtonView.clipsToBounds = true
        addButtonView.alpha = 0.7
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "RequestDetailCell", for: indexPath) as! RequestDetailTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        profileTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "requestDetailFromProfileSegue", sender: profileTableView.cellForRow(at: indexPath))
    }
    
    @IBAction func onAddButtonPress(_ sender: Any) {
        let alert = UIAlertController(title: "Add", message: "Add a New Pet or Create a New Request for your pet", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "New Pet", style: .default, handler: { (action: UIAlertAction) in
            print("Hit the Add a Pet Button!")
            self.performSegue(withIdentifier: "addPetFromProfileSegue", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "New Request", style: .default, handler: { (action: UIAlertAction) in
            print("Hit the Add a Request Button!")
            self.performSegue(withIdentifier: "addRequestFromProfileSegue", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
            print("Hit the Cancel Button!")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if(segue.identifier == "requestDetailFromProfileSegue") {
            let requestDetailVC = segue.destination as! EditRequestViewController
            let indexPath = profileTableView.indexPath(for: sender as! RequestDetailTableViewCell)
            requestDetailVC.request = requests?[(indexPath?.row)!]
        } 
        // Pass the selected object to the new view controller.
    }
    

}
