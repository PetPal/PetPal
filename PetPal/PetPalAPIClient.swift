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
        newUser["tagline"] = user.tagLine
        newUser["password"] = user.password
        newUser.signUpInBackground { (response: Bool, error: Error?) in
            if(error == nil){
                print("Successfully Signed up a User!")
                success(response)
            } else {
                print("There was an error Signing Up: \(error?.localizedDescription)")
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
                        print(object["name"] ?? "Default Name")
                    }
                }
            } else {
                print("There was an error fetching the Users : \(error?.localizedDescription)")
            }
        }
    }

}
