//
//  SettingsViewController.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 5/7/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var editProfilePhotoButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    let currentUser = User.currentUser
    
    var profileImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePicture.setRounded()
        
        editProfilePhotoButton.layer.borderColor = UIColor.black.cgColor
        editProfilePhotoButton.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddPetSegue") {
            let addPetVC = segue.destination as! AddPetViewController
            addPetVC.user = currentUser
        }
    }
    
    @IBAction func onEditProfilePhotoButton(_ sender: Any) {
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
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let newProfileImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //profileImage = newProfileImage
        self.profilePicture.image = newProfileImage
        let pfProfileImage = Utilities.getPFFileFromImage(image: newProfileImage)
        
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
