
//
//  ChatViewController.swift
//  PetPal
//
//  Created by Rui Mao on 4/26/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse


class ChatViewController: UIViewController {

    @IBOutlet weak var messageTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onSendButton(_ sender: UIButton) {
        let message = PFObject(className:"Message")
        message["user"] = 1337
        message["text"] = messageTextField.text

        message.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print ("Message has been saved.")
            } else {
                print ("Error: \(error?.localizedDescription)")
            }
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
