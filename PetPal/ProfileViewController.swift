//
//  ProfileViewController.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 4/30/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var petCount: UILabel!
    @IBOutlet weak var creditCount: UILabel!
    @IBOutlet weak var groupCount: UILabel!
    

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
