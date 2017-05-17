//
//  PetDetailTableViewCell.swift
//  PetPal
//
//  Created by LING HAO on 5/16/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import ParseUI

class PetDetailTableViewCell: UITableViewCell {

    @IBOutlet var petProfileImage: PFImageView!
    @IBOutlet var petName: UILabel!
    @IBOutlet var petAge: UILabel!
    @IBOutlet var petType: UILabel!
    @IBOutlet var petDescription: UILabel!
    
    var pet: Pet! {
        didSet {
            if let avatar = pet.petImage {
                petProfileImage.file = avatar
                petProfileImage.loadInBackground()
            }
            petName.text = pet.name
            if let age = pet.age {
                petAge.text = age > 1 ? String(age) + " year old" : String(age) + " years old"
            }
            petType.text = pet.type
            petDescription.text = pet.petDescription
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
