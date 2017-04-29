//
//  RequestDetailTableViewCell.swift
//  PetPal
//
//  Created by LING HAO on 4/27/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class RequestDetailTableViewCell: UITableViewCell {

    @IBOutlet var requestImageView: UIImageView!
    @IBOutlet var requestGroupLabel: UILabel!
    @IBOutlet var requestPetLabel: UILabel!
    @IBOutlet var requestDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        requestImageView.setRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
