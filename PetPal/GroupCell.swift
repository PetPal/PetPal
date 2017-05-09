//
//  GroupCell.swift
//  PetPal
//
//  Created by Rui Mao on 5/9/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupAvatar: PFImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var createdAtLabel: UILabel!
    
    var Group: PFObject! {
        didSet {
            self.groupAvatar.file = Group["groupAvatar"] as? PFFile
            self.groupAvatar.loadInBackground()
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
