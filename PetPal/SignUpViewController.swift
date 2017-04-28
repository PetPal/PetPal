//
//  SignUpViewController.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 4/28/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var taglineField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let alertController = UIAlertController(title: "Missed a Field!", message: "You missed a mandatory field on the SignUp", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        if (nameField.text == "" || userNameField.text == "" || emailField.text == "" || passwordField.text == ""){
            self.present(alertController, animated: true, completion: nil)
        } else {
            let newUser = User(newName: nameField.text!, newScreenName: userNameField.text!, newTagLine: taglineField.text!, newEmail: emailField.text!, newPassword: passwordField.text!)
            PetPalAPIClient.sharedInstance.addUser(user: newUser, success: { (bool: Bool) in
                print("Successfully Signed up user")
                alertController.title = "Sign Up Success"
                alertController.message = "Successfully signed up a new user."
                self.present(alertController, animated: true, completion: nil)
            }, failure: { (error: Error) in
                print("Failed to Signup User. : \(error.localizedDescription)")
                alertController.title = "Error"
                alertController.message = "\(error.localizedDescription)"
                self.present(alertController, animated: true, completion: nil)
            })
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
