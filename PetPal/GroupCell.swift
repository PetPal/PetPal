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
    @IBOutlet weak var membersCount: UILabel!
    var formatter = DateFormatter()

    var group: Group! {
        didSet {
            self.groupAvatar.file = group.profileImage
            self.groupAvatar.loadInBackground()
            self.nameLabel.text = group.name
            formatter.dateFormat = "MM/dd/yy"
            self.createdAtLabel.text = formatter.string(from: group.timeStamp!)
            if let count = group.memberCount {
                self.membersCount.text = String(describing: count)
            }
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
