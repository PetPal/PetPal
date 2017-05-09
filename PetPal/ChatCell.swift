//
//  ChatCell.swift
//  PetPal
//
//  Created by Rui Mao on 4/30/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ChatCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: PFImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var User: PFObject! {
        didSet {
            self.avatarImageView.file = User["userAvatar"] as? PFFile
            self.avatarImageView.loadInBackground()
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
