//
//  AddPetViewController.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 5/7/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse

class AddPetViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: User!
    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var petType: UITextField!
    @IBOutlet weak var petAge: UITextField!
    @IBOutlet weak var petDescription: UITextField!
    @IBOutlet weak var mainPetView: UIView!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petImageContainerView: UIView!
    @IBOutlet weak var changePetPictureButton: UIButton!
    @IBOutlet weak var petNameFieldContainer: UIView!
    @IBOutlet weak var petTypeFieldContainer: UIView!
    @IBOutlet weak var petAgeFieldContainer: UIView!
    @IBOutlet weak var petDescriptionFieldContainer: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User.currentUser
        petName.signupTextBox()
        petType.signupTextBox()
        petAge.signupTextBox()
        petDescription.signupTextBox()
        
        //Image Stuff
        petImageView.setRounded()
        let containerRadius = petImageContainerView.frame.width / 2
        petImageContainerView.layer.cornerRadius = containerRadius
        petImageContainerView.layer.borderColor = UIColor.black.cgColor
        petImageContainerView.layer.borderWidth = 1
        changePetPictureButton.layer.cornerRadius = 3
        changePetPictureButton.layer.borderColor = UIColor.darkGray.cgColor
        changePetPictureButton.layer.borderWidth = 0.5
        
        //TextField UI Effect
        petNameFieldContainer.layer.cornerRadius = 20
        petNameFieldContainer.alpha = 0.3
        petTypeFieldContainer.layer.cornerRadius = 20
        petTypeFieldContainer.alpha = 0.3
        petAgeFieldContainer.layer.cornerRadius = 20
        petAgeFieldContainer.alpha = 0.3
        petDescriptionFieldContainer.layer.cornerRadius = 20
        petDescriptionFieldContainer.alpha = 0.3
        
        
        //Background Gradient
        let topColor = UIColor(displayP3Red: (57.0/255.0), green: (147.0/255.0), blue: (227.0/255.0), alpha: 1)
        let bottomColor = UIColor(displayP3Red: (111.0/255.0), green: (116.0/255.0), blue: (163.0/255.0), alpha: 1)
        let background = CAGradientLayer().gradientBackground(topColor: topColor.cgColor, bottomColor: bottomColor.cgColor)
        background.frame = mainPetView.bounds
        mainPetView.layer.insertSublayer(background, at: 0)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPetPictureChange(_ sender: Any) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is Available")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            let newPetImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.petImageView.image = newPetImage
            self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onAddPetButton(_ sender: Any) {
        
        let name = petName.text
        let type = petType.text
        let age = Int(petAge.text!)
        let pfPetImage = Utilities.getPFFileFromImage(image: petImageView.image)
        let petDescription = self.petDescription.text
        
        if name != nil && type != nil && age != nil && petDescription != nil && pfPetImage != nil{
            
            let pet = Pet(petName: name!, petType: type!, petAge: age!, petDescription: petDescription!, petImage: pfPetImage!, petOwner: user)
            
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
