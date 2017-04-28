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
    var window: UIWindow?

    // add the OK action to the alert controller

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
                let alertController = UIAlertController(title: "Error", message: "Please enter your email address and password.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                print ("Error: \(error?.localizedDescription)")
            } else {
                                let alertController = UIAlertController(title: "Welcome to Petpal", message: "User \(self.emailTextField.text!) has successfully signed up!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let chatVC = mainStoryboard.instantiateViewController(withIdentifier: "chatVC") as! ChatViewController
                    self.window?.rootViewController = chatVC
                    //self.present(chatVC, animated: true, completion: nil)

                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                

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
               
                let alertController = UIAlertController(title: "Welcome to Petpal", message: "User \(self.emailTextField.text!) has successfully logged in!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let chatVC = mainStoryboard.instantiateViewController(withIdentifier: "chatVC") as! ChatViewController
                    self.present(chatVC, animated: true, completion: nil)
                    
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                
                
                print ("Successfully logged in!")
            } else {
                let alertController = UIAlertController(title: "Error", message: "Invalid email address or password.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                // The login failed. Check error to see why.
                print ("Error: \(error?.localizedDescription)")
            }
        }
    }
}
