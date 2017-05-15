//
//  CalendarViewController.swift
//  PetPal
//
//  Created by LING HAO on 5/12/17.
//  Copyright © 2017 PetPal. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let formatter = DateFormatter()
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let monthColor = UIColor(colorWithHexValue: 0x383852) // Dark navy
    let selectedDayColor = UIColor(colorWithHexValue: 0xF5F4F9) // Light offwhite
    let currentMonthDayColor = UIColor(colorWithHexValue: 0x383852) // Dark navy
    let nonMonthDayColor = UIColor(colorWithHexValue: 0xC2C4D6)
    
    var tasks: [Request]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendarView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension

        loadTasks()
        
        NotificationCenter.default.addObserver(forName: PetPalConstants.requestUpdated, object: nil, queue: OperationQueue.main) { (notification: Notification) in
            self.loadTasks()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = UIColor(colorWithHexValue: 0x7F44BF)
        navigationController?.navigationBar.tintColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func loadTasks() {
        let user = User.currentUser
        PetPalAPIClient.sharedInstance.getUserTasks(user: user!, success: { (requests: [Request]) in
            self.tasks = requests
            self.selectDates()
            self.tableView.reloadData()
        }) { (error: Error?) in
            print("error \(String(describing: error?.localizedDescription))")
        }
    }
    
    func selectDates() {
        if let tasks = tasks {
            for task in tasks {
                if let startDate = task.startDate, let endDate = task.endDate {
                    calendarView.selectDates(from: startDate, to: endDate, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
                }
                
            }
        }
    }


    // MARK: - UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskDetailTableViewCell", for: indexPath) as! TaskDetailTableViewCell
        cell.selectionStyle = .none
        cell.request = tasks![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskHeaderCell") as! TaskHeaderTableViewCell
        let hasCount = (tasks?.count ?? 0) > 0 ? true : false
        cell.header = hasCount ? "Tasks" : "No upcoming tasks"
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }


    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CalendarEditRequestSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let editRequestVC = segue.destination as! EditRequestViewController
                if let task = tasks?[indexPath.row] {
                    editRequestVC.request = task
                }
            }
        }
    }

}


extension CalendarViewController: JTAppleCalendarViewDataSource {
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

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateSelectCell", for: indexPath) as! CustomDateCell
        cell.dateLabel.text = cellState.text
        handleCellAppearance(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell, cellState: CellState) -> Bool {
        return false
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell, cellState: CellState) -> Bool {
        return false
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        handleCalendarLabel(visibleDate: visibleDates)
    }
    
}
