//
//  RequestDetailTableViewCell.swift
//  PetPal
//
//  Created by LING HAO on 5/7/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import ParseUI

class RequestDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var requestImageView: PFImageView!
    @IBOutlet var requestTitle: UILabel!
    @IBOutlet var requestInfo: UILabel!
    @IBOutlet var requestCategory: UILabel!
    @IBOutlet var elapsedTimeLabel: UILabel!
    @IBOutlet var startWeekDay: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endWeekDay: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    
    var formatter = DateFormatter()

    var request: Request! {
        didSet {
            var user: User?
            
            switch request.category {
            case .pendingRequest:
                requestTitle.text = "Sent to groups"
                user = request.requestUser
                if let groups = request.groups {
                    var str: String = ""
                    for group in groups {
                        if !str.isEmpty {
                            str += ", "
                        }
                        str += group.name ?? ""
                    }
                    requestInfo.text = str
                }
            case .acceptedRequest:
                requestTitle.text = "Accepted by"
                user = request.acceptUser
                requestInfo.text = user?.name
            case .task:
                requestTitle.text = "Task for"
                user = request.requestUser
                requestInfo.text = user?.name
            case .groupRequest:
                requestTitle.text = "Request from"
                user = request.requestUser
                requestInfo.text = user?.name
            }

            requestCategory.text = request.getCategoryString()
            
            if let avatar = user?.userAvatar {
                requestImageView.file = avatar
                requestImageView.loadInBackground()
            }
            
            if let acceptedAtDate = request.acceptDate {
                let elpased = acceptedAtDate.timeIntervalSinceNow
                elapsedTimeLabel.text = Utilities.timeElapsed(-elpased)
            } else if let createdAtDate = request.createdAtDate {
                let elpased = createdAtDate.timeIntervalSinceNow
                elapsedTimeLabel.text = Utilities.timeElapsed(-elpased)
            }

            if let startDate = request.startDate {
                formatter.dateFormat = "EEE"
                startWeekDay.text = formatter.string(from: startDate)
                formatter.dateFormat = "MMMM d, yyyy"
                startDateLabel.text = formatter.string(from: startDate)
                if let endDate = request.endDate {
                    formatter.dateFormat = "EEE"
                    endWeekDay.text = formatter.string(from: endDate)
                    formatter.dateFormat = "MMMM d, yyyy"
                    endDateLabel.text = formatter.string(from: endDate)
                } else {
                    formatter.dateFormat = "EEE"
                    endWeekDay.text = formatter.string(from: startDate)
                    formatter.dateFormat = "MMMM d, yyyy"
                    endDateLabel.text = formatter.string(from: startDate)
                }
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
