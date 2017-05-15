//
//  TaskDetailTableViewCell.swift
//  PetPal
//
//  Created by LING HAO on 5/12/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import ParseUI

class TaskDetailTableViewCell: UITableViewCell {

    @IBOutlet var taskDate: UILabel!
    @IBOutlet var taskProfileImage: PFImageView!
    @IBOutlet var taskType: UILabel!
    @IBOutlet var taskUserName: UILabel!
    @IBOutlet var taskAcceptedDate: UILabel!
    
    var request: Request! {
        didSet {
            var user: User?
            
            user = request.requestUser
            taskUserName.text = user?.name
            
            if let avatar = user?.userAvatar {
                taskProfileImage.file = avatar
                taskProfileImage.loadInBackground()
            }
            
            if let acceptedAtDate = request.acceptDate {
                let elpased = acceptedAtDate.timeIntervalSinceNow
                taskAcceptedDate.text = "Accepted " + Utilities.timeElapsed(-elpased)
            }
            
            if let startDate = request.startDate, let endDate = request.endDate {
                let dateStr = Utilities.formatStartEndDate(startDate: startDate, endDate: endDate)
                taskDate.text = dateStr
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskProfileImage.setRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
