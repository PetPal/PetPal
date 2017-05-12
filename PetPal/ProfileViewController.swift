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
    

    var requests: [Request]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        let user = User.currentUser
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
