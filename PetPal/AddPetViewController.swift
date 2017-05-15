//
//  AddPetViewController.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 5/7/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class AddPetViewController: UIViewController {
    
    var user: User!
    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var petType: UITextField!
    @IBOutlet weak var petAge: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        petName.signupTextBox()
        petType.signupTextBox()
        petAge.signupTextBox()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onAddPetButton(_ sender: Any) {
        
        let name = petName.text
        let type = petType.text
        let age = Int(petAge.text!)
        
        if name != nil && type != nil && age != nil {
            
            let pet = Pet(petName: name!, petType: type!, petAge: age!, petOwner: user)
            
            PetPalAPIClient.sharedInstance.addPet(pet: pet, success: { (pet: Pet) in
                print("Successfully Added a Pet to the Pet Table")
            }, failure: { (error: Error?) in
                print("Error: \(error?.localizedDescription ?? "Error Value in Nil")")
            }, completion: {
                
                PetPalAPIClient.sharedInstance.addPetToUser(pet: pet, success: { (user: User) in
                    print("Owner has a pet!")
                    self.dismiss(animated: true, completion: nil)
                }) {(error: Error?) in
                    print("Error: \(error?.localizedDescription ?? "Error Value is Nil")")
                }
            })
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
