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
    @IBOutlet weak var petAddButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    

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
        
        
        //Button Styling
        petAddButton.greenButton()
        cancelButton.greenButton()
        cancelButton.setTitleColor(UIColor.red, for: .normal)
        
        
        //Background Gradient
        let topColor = UIColor(displayP3Red: (57.0/255.0), green: (147.0/255.0), blue: (227.0/255.0), alpha: 1)
        let bottomColor = UIColor(displayP3Red: (111.0/255.0), green: (116.0/255.0), blue: (163.0/255.0), alpha: 1)
        let background = CAGradientLayer().gradientBackground(topColor: topColor.cgColor, bottomColor: bottomColor.cgColor)
        background.frame = mainPetView.bounds
        mainPetView.layer.insertSublayer(background, at: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(recognizer:)))
        view.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPetPictureChange(_ sender: Any) {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is Available")
            imagePicker.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            imagePicker.sourceType = .photoLibrary
        }
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            let newPetImage = info[UIImagePickerControllerOriginalImage] as! UIImage

            self.petImageView.image = newPetImage
            self.dismiss(animated: true, completion: nil)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 57/256, green: 127/256, blue: 204/256, alpha: 1.0)
        viewController.navigationController?.navigationBar.tintColor = UIColor.white
        if(imagePicker.sourceType == UIImagePickerControllerSourceType.photoLibrary){
            let button = UIBarButtonItem(title: "Take Photo", style: .plain, target: self, action: #selector(showCamera))
            viewController.navigationItem.rightBarButtonItem = button
            
        } else {
            let button = UIBarButtonItem(title: "Choose Photo", style: .plain, target: self, action: #selector(showPhotoLibrary))
            viewController.navigationItem.rightBarButtonItem = button
            viewController.navigationController?.isNavigationBarHidden = false
            viewController.navigationController?.navigationBar.isTranslucent = true
        }
    }
    
    func showCamera(){
        imagePicker.sourceType = .camera
    }
    
    func showPhotoLibrary(){
        imagePicker.sourceType = .photoLibrary
    }
    
    @IBAction func onAddPetButton(_ sender: Any) {
        
        let name = petName.text
        let type = petType.text
        let age = Int(petAge.text!)
        let compressedPetImage = petImageView.image?.compress()
        let pfPetImage = Utilities.getPFFileFromImage(image: compressedPetImage)
        let petDescription = self.petDescription.text
        
        if name != nil && type != nil && age != nil && petDescription != nil && pfPetImage != nil{
            
            let pet = Pet(petName: name!, petType: type!, petAge: age!, petDescription: petDescription!, petImage: pfPetImage!, petOwner: user)
            let pfPet = pet.makePFObject()
            pet.pfPet = pfPet
            
            PetPalAPIClient.sharedInstance.addPet(pet: pet, success: { (pet: Pet) in
                print("Successfully Added a Pet to the Pet Table")
            }, failure: { (error: Error?) in
                print("Error: \(error?.localizedDescription ?? "Error Value in Nil")")
            }, completion: {
                
                PetPalAPIClient.sharedInstance.addPetToUser(pet: pet, success: { (user: User) in
                    print("Owner has a pet!")
                    
                }) {(error: Error?) in
                    print("Error: \(error?.localizedDescription ?? "Error Value is Nil")")
                }
                PetPalAPIClient.sharedInstance.populatePets(forUser: User.currentUser!)
                self.dismiss(animated: true, completion: nil)
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
