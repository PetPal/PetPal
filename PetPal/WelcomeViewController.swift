//
//  WelcomeViewController.swift
//  PetPal
//
//  Created by Rui Mao on 4/28/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse

class WelcomeViewController: UIViewController {

    @IBOutlet var userTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSignIn(_ sender: Any) {
        let username = userTextField.text
        let password = passwordTextField.text
        PFUser.logInWithUsername(inBackground: (username)!, password:(password)!) {
            (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                Utilities.presentHamburgerView(window: UIApplication.shared.keyWindow)
                print ("Successfully logged in!")
            } else {
                // The login failed. Check error to see why.
                let alertController = UIAlertController(title: "Error", message: "Invalid username or password.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            }
        }
    }
}
