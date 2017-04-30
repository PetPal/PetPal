//
//  LoginViewController.swift
//  PetPal
//
//  Created by Rui Mao on 4/27/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse
import AFNetworking


class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self

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

    
    
 
    
    @IBAction func onLoginButton(_ sender: UIButton) {
        self.login()
    }
    
    func login() {
        let email = self.emailTextField.text?.lowercased()
        let password = self.passwordTextField.text
        PFUser.logInWithUsername(inBackground: (email)!, password:(password)!) {
            (user: PFUser?, error: Error?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                let alertController = UIAlertController(title: "Welcome to Petpal", message: "Welcome back, \(user!["username"]!)", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Ok" , style: .default) { (action) in
                    //Mark
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let groupVC = mainStoryboard.instantiateViewController(withIdentifier: "groupVC") as! GroupViewController
                    self.present(groupVC, animated: true, completion: nil)
                    //Mark
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                print ("Successfully logged in!")
            } else {
                // The login failed. Check error to see why.
                let alertController = UIAlertController(title: "Error", message: "Invalid email address or password.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                print ("Error: \(error?.localizedDescription)")
            }
        }
    }
}
