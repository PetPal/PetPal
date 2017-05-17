//
//  ProfileViewController.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 4/30/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import ParseUI

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var petCount: UILabel!
    @IBOutlet weak var creditCount: UILabel!
    @IBOutlet weak var groupCount: UILabel!
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var profileContainerView: UIView!
    @IBOutlet weak var imageBorderView: UIView!
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editProfilePictureButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    

    var requests: [Request]?
    var pets: [Pet]?
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        //set Nav bar color
        navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 57/256, green: 127/256, blue: 204/256, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.white

        if(user == nil){
         user = User.currentUser
        }
        
        if user != User.currentUser {
            addButtonView.isHidden = true
            addButton.isHidden = true
        }
        
        
        //Getting all the User's Pets
        PetPalAPIClient.sharedInstance.populatePets(forUser: user!)
        
        profileTableView.estimatedRowHeight = 320
        profileTableView.rowHeight = UITableViewAutomaticDimension
        
        //Updating data on labels
        nameLabel.text = user?.name
        petCount.text = "\(user?.pets?.count ?? 0)"
        groupCount.text = "\(user?.groups?.count ?? 0)"
        
        //Updating the profileImage
        if let avatar = user?.userAvatar {
            profileImage.file = avatar
            profileImage.loadInBackground()
            profileImage.setRounded()
        }
        let radius = imageBorderView.frame.width / 2
        imageBorderView.layer.cornerRadius = radius
        imageBorderView.layer.borderColor = UIColor.darkGray.cgColor
        imageBorderView.layer.borderWidth = 1
        
        
        let addButtonRadius = addButtonView.frame.width / 2
        addButtonView.layer.cornerRadius = addButtonRadius
        addButtonView.clipsToBounds = true
        addButtonView.alpha = 0.7
        
        let editButtonRadius = 3
        editProfilePictureButton.layer.cornerRadius = CGFloat(editButtonRadius)
        editProfilePictureButton.clipsToBounds = true
        editProfilePictureButton.layer.borderColor = UIColor.black.cgColor
        editProfilePictureButton.layer.borderWidth = 0.5
        editProfilePictureButton.backgroundColor = UIColor(colorLiteralRed: 57/256, green: 127/256, blue: 204/256, alpha: 1.0)
        
        NotificationCenter.default.addObserver(forName: PetPalConstants.petAdded, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.profileTableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(forName: PetPalConstants.userPetUpdated, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            let petUser = notification.object as! User
            if petUser.isEqual(self.user) {
                self.profileTableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        petCount.text = "\(user?.pets?.count ?? 0)"
        groupCount.text = "\(user?.groups?.count ?? 0)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return user?.pets?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetDetailTableViewCell", for: indexPath) as! PetDetailTableViewCell
        cell.pet = user!.pets![indexPath.row]
        return cell
    }
    
    @IBAction func onEditProfilePhoto(_ sender: Any) {
        
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
        do{
            let newProfileImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            self.profileImage.image = newProfileImage
            let compressedImage = newProfileImage.compress()
            let pfProfileImage = Utilities.getPFFileFromImage(image: compressedImage)
            try pfProfileImage?.save()
            User.currentUser?.userAvatar = pfProfileImage
            
            PetPalAPIClient.sharedInstance.updateUserProfilePicture(profilePicture: pfProfileImage!, success: { (response: Bool) in
                print("Successfully save the Current User's Profile Picture.")
            }, failure: { (error: Error) in
                print("Error saving the current user's profile picture: \(error.localizedDescription)")
            })
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Error while Saving the Profile Picture")
        }
        
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
    
    
    
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        profileTableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: "requestDetailFromProfileSegue", sender: profileTableView.cellForRow(at: indexPath))
//    }
    
    @IBAction func onAddButtonPress(_ sender: Any) {
        let alert = UIAlertController(title: "Add", message: "Add a New Pet or Create a New Request for your pet", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "New Pet", style: .default, handler: { (action: UIAlertAction) in
            print("Hit the Add a Pet Button!")
            self.performSegue(withIdentifier: "addPetFromProfileSegue", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "New Request", style: .default, handler: { (action: UIAlertAction) in
            print("Hit the Add a Request Button!")
            self.performSegue(withIdentifier: "addRequestFromProfileSegue", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
            print("Hit the Cancel Button!")
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if(segue.identifier == "requestDetailFromProfileSegue") {
            let requestDetailVC = segue.destination as! EditRequestViewController
            let indexPath = profileTableView.indexPath(for: sender as! RequestDetailTableViewCell)
            requestDetailVC.request = requests?[(indexPath?.row)!]
        } 
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func onEditProfileImage(_ sender: Any) {
        print("onEditProfileImage")
    }

}
