//
//  TaskHeaderTableViewCell.swift
//  PetPal
//
//  Created by LING HAO on 5/12/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class TaskHeaderTableViewCell: UITableViewCell {

    @IBOutlet var headerLabel: UILabel!
    
    var header: String! {
        didSet {
            headerLabel.text = header
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
