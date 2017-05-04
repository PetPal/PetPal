//
//  NewGroupViewController.swift
//  PetPal
//
//  Created by Rui Mao on 5/2/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class NewGroupViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    
    
    @IBOutlet weak var descriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.descriptionTextField.text = ""
        self.descriptionTextField.textColor = UIColor.black
    }
    
    @IBAction func onCancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func onCreateButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Missed a Field!", message: "You missed a mandatory field when creating a new group", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        if (nameTextField.text == "" || zipcodeTextField.text == "" || descriptionTextField.text == ""){
            self.present(alertController, animated: true, completion: nil)
        } else {
            let newgroup = Group(name: nameTextField.text!, type: GroupType(rawValue: 0)!, owner: User.currentUser!, zipcode: Int(zipcodeTextField.text!)!, overview: descriptionTextField.text!)
            PetPalAPIClient.sharedInstance.addGroup(group: newgroup)
            self.dismiss(animated: true, completion: nil)
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
