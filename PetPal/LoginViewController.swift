//
//  LoginViewController.swift
//  PetPal
//
//  Created by Rui Mao on 4/27/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onSignupButton(_ sender: UIButton) {
        let user = PFUser()
        let username = self.emailTextField.text
        let password = self.passwordTextField.text
        
        user.username = username
        user.password = password
        //user.email = "email@example.com"
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"
        
        user.signUpInBackground {
            (succeeded: Bool, error: Error?) -> Void in
            if error != nil {
                print ("Error when signing up a user.")
            } else {
                print ("Successfully signed up the user: \(self.emailTextField.text)")
            }
        }
    }
    
    
    @IBAction func onLoginButton(_ sender: UIButton) {
        let username = self.emailTextField.text
        let password = self.passwordTextField.text

        PFUser.logInWithUsername(inBackground: (username)!, password:(password)!) {
            (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                print ("Successfully logged in!")
            } else {
                // The login failed. Check error to see why.
                print ("Error: \(error?.localizedDescription)")
            }
        }
    }
}
