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
    
    var keyboardOffset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(recognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deregisterKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(animateUpForKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateDownForKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateUpForKeyboard() {
        if keyboardOffset == 0 {
            keyboardOffset = -180
            UIView.animate(withDuration: 0.3) {
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(self.keyboardOffset))
            }
        }
    }
    
    func animateDownForKeyboard() {
        if keyboardOffset < 0 {
            let offset = -keyboardOffset
            keyboardOffset = 0
            UIView.animate(withDuration: 0.3) {
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: CGFloat(offset))
            }
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
