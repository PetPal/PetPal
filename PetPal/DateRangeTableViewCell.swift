//
//  DateRangeTableViewCell.swift
//  PetPal
//
//  Created by LING HAO on 5/5/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit

struct DateRange {
    var startDate: Date?
    var endDate: Date?
    
    init(startDate: Date?, endDate: Date?) {
        self.startDate = startDate
        self.endDate = endDate
    }
}

class DateRangeTableViewCell: UITableViewCell {
    
    @IBOutlet var startWeekDay: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endWeekDay: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    
    var formatter = DateFormatter()
    
    var dateRange: DateRange? {
        didSet {
            if let startDate = dateRange?.startDate {
                formatter.dateFormat = "EEE"
                startWeekDay.text = formatter.string(from: startDate)
                formatter.dateFormat = "MMMM d, yyyy"
                startDateLabel.text = formatter.string(from: startDate)
                if let endDate = dateRange?.endDate {
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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
