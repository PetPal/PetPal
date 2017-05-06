//
//  DateSelectViewController.swift
//  PetPal
//
//  Created by LING HAO on 5/3/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import JTAppleCalendar

@objc protocol DateSelectViewControllerDelegate: class {
    @objc optional func dateSelected(dateSelectViewController: DateSelectViewController, startDate: Date, endDate: Date)
}

class DateSelectViewController: UIViewController {
    
    let formatter = DateFormatter()
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var selectedDateLabel: UILabel!
    
    weak var delegate: DateSelectViewControllerDelegate?
    
    let monthColor = UIColor.white
    let selectedDayColor = UIColor(colorWithHexValue: 0xE08E43)
    let currentMonthDayColor = UIColor.white
    let nonMonthDayColor = UIColor(colorWithHexValue: 0xEF9F40)
    
    var startDate: Date?
    var endDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendarView()
        
        setupBackground()
    }

    func setupCalendarView() {
        // setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.allowsMultipleSelection = true
        
        // Setup labels
        calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
            self.handleCalendarLabel(visibleDate: visibleDates)
        }
    }
    
    func setupBackground() {
        /*
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: "pumpkinBackground")?.draw(in: view.bounds)
        if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            view.backgroundColor = UIColor(patternImage: image)
        }
        */
    }
    
    func handleCalendarLabel(visibleDate: DateSegmentInfo) {
        let date = visibleDate.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)

    }
    
    func handleCellAppearance(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomDateCell else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
            validCell.dateLabel.textColor = selectedDayColor
        } else {
            validCell.selectedView.isHidden = true
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = currentMonthDayColor
            } else {
                validCell.dateLabel.textColor = nonMonthDayColor
            }
        }
    }
    
    func handleSelectedDate() {
        if startDate == nil {
            selectedDateLabel.text = "Select a start date"
        } else if endDate == nil {
            selectedDateLabel.text = "Select an end date"
        } else {
            selectedDateLabel.text = Utilities.formatStartEndDate(startDate: startDate!, endDate: endDate!)
        }
    }

    @IBAction func onClearButton(_ sender: Any) {
        startDate = nil
        endDate = nil
        calendarView.deselectAllDates(triggerSelectionDelegate: false)
    }
    
    @IBAction func onExitButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSaveButton(_ sender: Any) {
        if let startDate = startDate {
            if endDate == nil {
                endDate = startDate
            }
            delegate?.dateSelected?(dateSelectViewController: self, startDate: startDate, endDate: endDate!)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension DateSelectViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = Date()
        let endDate = startDate.addingTimeInterval(TimeInterval(60 * 60 * 24 * 356))
        let parameter = ConfigurationParameters.init(startDate: startDate, endDate: endDate)
        return parameter
    }
    
}

extension DateSelectViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateSelectCell", for: indexPath) as! CustomDateCell
        cell.dateLabel.text = cellState.text
        handleCellAppearance(view: cell, cellState: cellState)
        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if startDate == nil {
            startDate = date
        } else if endDate == nil {
            if date.compare(startDate!) == .orderedAscending {
                startDate = date
            } else {
                endDate = date
                calendar.selectDates(from: startDate!, to: endDate!, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            }
        } else {
            if date.compare(startDate!) == .orderedDescending || date.compare(endDate!) == .orderedAscending {
                calendarView.deselectDates(from: startDate!, to: endDate!, triggerSelectionDelegate: false)

                startDate = date
                endDate = nil
            }
        }
        handleSelectedDate()
        handleCellAppearance(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellAppearance(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell, cellState: CellState) -> Bool {
        return false
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        handleCalendarLabel(visibleDate: visibleDates)
    }
    
}


