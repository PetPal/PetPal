//
//  SettingsViewController.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 5/7/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    let currentUser = User.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePicture.setRounded()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddPetSegue") {
            let addPetVC = segue.destination as! AddPetViewController
            addPetVC.user = currentUser
        }
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
