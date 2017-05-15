//
//  BasicTableViewCell.swift
//  PetPal
//
//  Created by LING HAO on 5/7/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import ParseUI

class BasicTableViewCell: UITableViewCell {

    @IBOutlet var basicImage: PFImageView!
    @IBOutlet var basicLabel: UILabel!
    @IBOutlet var labelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var checkImage: UIImageView!
    @IBOutlet var uncheckImage: UIImageView!
    
    var group: Group? {
        didSet {
            if let group = group {
                basicLabel.text = group.name
                if let avatar = group.profileImage {
                    basicImage.setSquare()
                    basicImage.file = avatar
                    basicImage.loadInBackground()
                    labelLeadingConstraint.constant = 48
                } else {
                    labelLeadingConstraint.constant = 8
                }
            }
        }
    }
    
    var user: User? {
        didSet {
            if let user = user {
                basicLabel.text = user.name
                if let avatar = user.userAvatar {
                    basicImage.setRounded()
                    basicImage.file = avatar
                    basicImage.loadInBackground()
                    labelLeadingConstraint.constant = 48
                } else {
                    labelLeadingConstraint.constant = 8
                }
            }
        }
    }
    
    var basicText: String? {
        didSet {
            basicLabel.text = basicText
            labelLeadingConstraint.constant = 8
        }
    }
    
    var checkSelected: Bool? {
        didSet {
            if let selected = checkSelected {
                if selected == true {
                    uncheckImage.isHidden = true
                    checkImage.isHidden = false
                } else if selected == false {
                    checkImage.isHidden = true
                    uncheckImage.isHidden = false
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        checkImage.isHidden = true
        uncheckImage.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
