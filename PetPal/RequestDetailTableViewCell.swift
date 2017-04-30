//
//  RequestDetailTableViewCell.swift
//  PetPal
//
//  Created by LING HAO on 4/27/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

class RequestDetailTableViewCell: UITableViewCell {

    @IBOutlet var requestStatusLabel: UILabel!
    @IBOutlet var requestImageView: UIImageView!
    @IBOutlet var requestGroupLabel: UILabel!
    @IBOutlet var requestPetLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    
    var request: Request? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "M/d/yy"
            startDateLabel.text = formatter.string(from: request!.startDate!)
            endDateLabel.text = formatter.string(from: request!.endDate!)
            
            if let groups = request?.groups {
                requestGroupLabel.text = groups[0].name
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        requestImageView.setRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
