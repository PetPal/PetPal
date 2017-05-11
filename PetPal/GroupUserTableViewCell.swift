//
//  GroupUserTableViewCell.swift
//  PetPal
//
//  Created by LING HAO on 5/10/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import ParseUI

class GroupUserTableViewCell: UITableViewCell {

    @IBOutlet var userImage: PFImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userLocation: UILabel!
    
    var user: User? {
        didSet {
            if let user = user {
                userName.text = user.name
                if let pets = user.pets {
                    var petStr: String = ""
                    for pet in pets {
                        if !petStr.isEmpty {
                            petStr += ","
                        }
                        petStr += pet.name!
                    }
                    print(petStr)
                }
                if let avatar = user.userAvatar {
                    userImage.file = avatar
                    userImage.loadInBackground()
                }
                if let city = user.city, let state = user.state {
                    userLocation.text = city + ", " + state
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        userImage.setRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
