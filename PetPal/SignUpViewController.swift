//
//  SignUpViewController.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 4/28/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signUpWithTwitter: UIButton!
   
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Background Styling
        //let topColor = UIColor(displayP3Red: (142.0/255.0), green: (92.0/255.0), blue: (213.0/255.0), alpha: 1)
        let topColor = UIColor(displayP3Red: (10.0/255.0), green: (15.0/255.0), blue: (68.0/255.0), alpha: 1)
        let bottomColor = UIColor(displayP3Red: (112.0/255.0), green: (116.0/255.0), blue: (161.0/255.0), alpha: 1)
        let background = CAGradientLayer().gradientBackground(topColor: topColor.cgColor, bottomColor: bottomColor.cgColor)
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        //Button Styling
        signUpButton.greenButton()
        signUpWithTwitter.layer.cornerRadius = 4
        signUpWithTwitter.backgroundColor = UIColor(displayP3Red: (0/255.0), green: (172.0/255.0), blue: (237.0/255.0), alpha: 1)
        
        //TextBoxView Formatting
        nameView.layer.cornerRadius = 20
        nameView.alpha = 0.3
        usernameView.layer.cornerRadius = 20
        usernameView.alpha = 0.3
        emailView.layer.cornerRadius = 20
        emailView.alpha = 0.3
        passwordView.layer.cornerRadius = 20
        passwordView.alpha = 0.3
        
        //Textbox Formatting
        nameField.signupTextBox()
        userNameField.signupTextBox()
        emailField.signupTextBox()
        passwordField.signupTextBox()
        //Tap Gesture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let alertController = UIAlertController(title: "Missed a Field!", message: "You missed a mandatory field on the SignUp", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        // Starting a Spinner
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        spinner.startAnimating()
        
        if (nameField.text == "" || userNameField.text == "" || emailField.text == "" || passwordField.text == ""){
            self.present(alertController, animated: true, completion: nil)
        } else {
            let newUser = User(newName: nameField.text!, newScreenName: userNameField.text!, newEmail: emailField.text!, newPassword: passwordField.text!)
            PetPalAPIClient.sharedInstance.addUser(user: newUser, success: { (bool: Bool) in
                print("Successfully Signed up user")
                spinner.stopAnimating()
                //Logging User Upon SignUp
                User.currentUser = newUser
                Utilities.presentHamburgerView(window: UIApplication.shared.keyWindow)
                
            }, failure: { (error: Error) in
                print("Failed to Signup User. : \(error.localizedDescription)")
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
