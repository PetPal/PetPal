//
//  PetPalAPIClient.swift
//  PetPal
//
//  Created by Sabareesh Kappagantu on 4/28/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse

class PetPalAPIClient  {
    
    static let sharedInstance = PetPalAPIClient()
    
    func initializeParse(){
        Parse.initialize(with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) in
            configuration.applicationId = "petpal2-id"
            configuration.server = "https://petpal2.herokuapp.com/parse"
        }))
    }
    
    func addUser(user: User, success: @escaping (Bool) -> (), failure: @escaping (Error) -> ()){
        let newUser = PFUser()
        newUser["name"] = user.name
        newUser.username = user.screenName
        newUser.email = user.email
        newUser["password"] = user.password
        
        let imageData = UIImageJPEGRepresentation(UIImage(named:"defaultProfileImage")!, 0.05)
        let imageFile = PFFile(name: "image.jpg", data: imageData!)
        do {
            try imageFile?.save()
        } catch {
            print(error)
        }
        newUser.setObject(imageFile!, forKey: "userAvatar")
        
        newUser.signUpInBackground { (response: Bool, error: Error?) in
            if(error == nil){
                print("Successfully Signed up a User!")
                success(response)
            } else {
                print("There was an error Signing Up: \(error?.localizedDescription ?? "Error")")
                failure(error!)
            }
        }
    }
    
    func getUsers() {
        let query = PFQuery(className: "_User")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                print("Successfully Retrieved the Users!")
                if let objects = objects{
                    for object in objects {
                        print(object["name"])
                    }
                }
            } else {
                print("There was an error fetching the Users : \(error?.localizedDescription ?? "Error")")
            }
        }
    }
    
    func addGroupToUser(user: User, group: Group) {
        let pfUser = user.pfUser
        let relation = pfUser!.relation(forKey: "groups")
        let pfGroup = group.pfObject!
        relation.add(pfGroup)
        pfUser?.saveInBackground(block: { (success: Bool, error: Error?) in
            if success {
                print("add group to user successfully")
            } else {
                print("failed to add group to user")
            }
        })
    }
    
    func populateGroups(forUser user: User) {
        let pfUser = user.pfUser
        let relation = pfUser!.relation(forKey: "groups")
        relation.query().findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                var groups = [Group]()
                if let objects = objects {
                    for object in objects {
                        let group = Group(object: object)
                        groups.append(group)
                        
                    }
                    user.groups = groups
                    
                    NotificationCenter.default.post(name: PetPalConstants.userGroupUpdated, object: user)
                }
            }
        }
    }
    
    func addRequest(request: Request) {
        let requestObject: PFObject! = request.makePFObject()
        requestObject.saveInBackground { (success: Bool, error: Error?) in
            if success {
                let request = Request(object: requestObject)
                NotificationCenter.default.post(name: PetPalConstants.requestAdded, object: request)
                
                print("request added")
            } else if let error = error {
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    func updateRequest(request: Request) {
        guard let pfObject = request.pfObject else { return }
        let requestObject: PFObject! = request.updatePFObject(requestObject: pfObject)
        requestObject.saveInBackground { (success: Bool, error: Error?) in
            if success {
                NotificationCenter.default.post(name: PetPalConstants.requestUpdated, object: request)
                print("request updated")
            } else if let error = error {
                print("error \(error.localizedDescription)")
            }
        }
    }

    func getRequests(user: User, success: @escaping ([Request]) -> (), failure: @escaping (Error?) -> ()) {
        let query = PFQuery(className: "Request")
        query.includeKey("requestUser")
        query.includeKey("acceptUser")
        query.includeKey("groupIds")
        if let pfUser = user.pfUser {
            query.whereKey("requestUser", equalTo: pfUser)
        }
        // TODO add where clause for acceptUser
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                var requests = [Request]()
                if let objects = objects {
                    for object in objects {
                        let request = Request(object: object)
                        requests.append(request)
                    }
                }
                success(requests)
            } else {
                failure(error)
            }
        }
    }

    func getRequestInUserGroup(user: User, success: @escaping ([Request]) -> (), failure: @escaping (Error?) -> ()) {
        guard let userGroups = user.groups else { return }

        let query = PFQuery(className: "Request")
        query.includeKey("requestUser")
        query.includeKey("acceptUser")
        query.includeKey("groupIds")
        var groupIds = [String]()
        for group in userGroups {
            if let objectId = group.pfObject?.objectId {
                groupIds.append(objectId)
            }
        }
        query.whereKey("groupIds", containedIn: groupIds)
        
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                var requests = [Request]()
                if let objects = objects {
                    for object in objects {
                        let request = Request(object: object)
                        requests.append(request)
                    }
                }
                success(requests)
            } else {
                failure(error)
            }
        }
    }
    
    func addGroup(group: Group) {
        let groupObject = PFObject(className: "Group")
        if let name = group.name {
            groupObject["name"] = name
        }
        groupObject["groupType"] = group.type.rawValue
        if let owner = group.owner {
            groupObject["owner"] = owner.pfUser
        }
        groupObject["groupAvatar"] = Utilities.getPFFileFromImage(image: group.profileImage)
        groupObject.saveInBackground { (success: Bool, error: Error?) in
            if success {
                print("group added")
                NotificationCenter.default.post(name: PetPalConstants.groupAdded, object: group)
            } else if let error = error {
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    func getGroups(location: Int, success: @escaping ([Group]) -> (), failure: @escaping (Error?) -> ()) {
        let query = PFQuery(className: "Group")
     
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                var groups = [Group]()
                if let objects = objects {
                    for object in objects {
                        let group = Group(object: object)
                        groups.append(group)
                    }
                }
                success(groups)
            } else {
                failure(error)
            }
        }
    }
    
    
    func addPet(pet: Pet, success: @escaping (Pet) -> (), failure: @escaping (Error?) -> (), completion: @escaping () -> ()) {
        let petObject: PFObject! = pet.makePFObject()
        
        
        petObject.saveInBackground { (successSavePet: Bool, error: Error?) in
            if successSavePet {
                print("pet added")
                //NotificationCenter.default.post(name: PetPalConstants.petAdded, object: pet)
                success(pet)
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                failure(error)
            }
        }
        completion()
    }

    
    
    func addPetToUser(pet: Pet, success: @escaping (User) -> (), failure: @escaping (Error?) -> ()) {
        let user = pet.owner
        let pfUser = user?.pfUser
        let petObject: PFObject! = pet.makePFObject()
        let relation = pfUser!.relation(forKey: "Pets")
        relation.add(petObject)
        
        pfUser?.saveInBackground(block: { (successSavePetToUser: Bool, error: Error?) in
            if successSavePetToUser {
                print("Saved Pets to User!")
                success(user!)
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                failure(error)
            }
        })
    }

}
