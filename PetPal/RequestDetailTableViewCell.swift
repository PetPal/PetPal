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
    
    var request: Request? {
        didSet {
            if let startDate = request?.startDate, let endDate = request?.endDate {
                startDateLabel.text = Utilities.formatStartEndDate(startDate: startDate, endDate: endDate)
            }
            
            let isOurRequest = User.currentUser?.isEqual(request?.requestUser)
            let isOurTask = User.currentUser?.isEqual(request?.acceptUser)
            if isOurRequest ?? false {
                if request?.acceptUser == nil {
                    requestStatusLabel.text = "Pending Request"
                } else {
                    requestStatusLabel.text = "Accepted Request"
                }
            } else if isOurTask ?? false {
                requestStatusLabel.text = "Task"
            } else {
                requestStatusLabel.text = "Group Request"
                
            }
            
            // TODO include pet name
            
            if request!.requestType == RequestType.boardingType {
                requestPetLabel.text = "Boarding"
            } else {
                requestPetLabel.text = "Drop in visit"
            }
            
            if let groups = request?.groups {
                var str: String = ""
                for group in groups {
                    if !str.isEmpty {
                        str += ", "
                    }
                    str += group.name ?? ""
                }
                requestGroupLabel.text = str
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
