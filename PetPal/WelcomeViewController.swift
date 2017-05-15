//
//  WelcomeViewController.swift
//  PetPal
//
//  Created by Rui Mao on 4/28/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse

class WelcomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var userTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userTextField.delegate = self
        passwordTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(recognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateTextField(moveUp: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateTextField(moveUp: false)
    }
    
    func animateTextField(moveUp: Bool) {
        let offset = moveUp ? -180 : 180
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(offset))
        }
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
