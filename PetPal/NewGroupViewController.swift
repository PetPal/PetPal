//
//  NewGroupViewController.swift
//  PetPal
//
//  Created by Rui Mao on 5/2/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import QuartzCore

class NewGroupViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var groupTypeSegment: UISegmentedControl!

    var photo: UIImage!
    var processedPhoto: PFFile?
    var defaultGroupPhoto = Utilities.getPFFileFromImage(image: #imageLiteral(resourceName: "defaultGroupImage"))
    var snowView: SnowView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 157/256, green: 169/256, blue: 61/256, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white
        descriptionTextField.delegate = self
        nameTextField.autocorrectionType = .no
        descriptionTextField.autocorrectionType = .no
        
        //snow effect
        
       /* snowView = SnowView(frame: CGRect(x: -150, y:-100, width: 300, height: 50))
        let snowClipView = UIView(frame: view.frame.offsetBy(dx: 0, dy: 50))
        snowClipView.clipsToBounds = true
        snowClipView.addSubview(snowView)
        view.addSubview(snowClipView)
      */

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
   
    @IBAction func onCameraButton(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = false
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        //vc.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(vc, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photo = originalImage
        processedPhoto = Utilities.getPFFileFromImage(image: photo)
        
        self.cameraButton.setImage(originalImage, for: UIControlState.normal)
       
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onCreateButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Missed a Field!", message: "You missed a mandatory field when creating a new group", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        
        if (nameTextField.text == "" ||  descriptionTextField.text == ""){
            self.present(alertController, animated: true, completion: nil)
        } else {
            let newgroup = Group(name: nameTextField.text!, type: GroupType(rawValue: self.groupTypeSegment.selectedSegmentIndex)!, owner: User.currentUser!, timeStamp: Date(), overview: descriptionTextField.text!, profileImage: processedPhoto ?? defaultGroupPhoto! , location: (User.currentUser?.location!)!, memberCount: 0)
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
