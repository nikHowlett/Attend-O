//
//  NewViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 4/5/16.
//  Copyright © 2016 NikHowlett. All rights reserved.
//

import UIKit
import NSDate_Escort
import MJCalendar

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

struct DayColors {
    var backgroundColor: UIColor
    var textColor: UIColor
}

class NewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MJCalendarViewDelegate {

    @IBOutlet weak var calendarView: MJCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    
    var dayColors = Dictionary<NSDate, DayColors>()
    var dateFormatter: NSDateFormatter!
    var colors: [UIColor] {
        return [
            UIColor(netHex: 0xF6980B),
            UIColor(netHex: 0x2081D9),
            UIColor(netHex: 0x2FBD8F),
            //UIColor(netHex:0xFFFFFF)
        ]
    }
    
    let daysRange = 365
    var isScrollingAnimation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDays()
        
        self.setUpCalendarConfiguration()
        
        self.dateFormatter = NSDateFormatter()
        self.setTitleWithDate(NSDate())
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.daysRange
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell") as! TableViewCell
        
        let date = self.dateByIndex(indexPath.row)
        self.dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let dateString = self.dateFormatter.stringFromDate(date)
        cell.dateLabel.text = dateString
        cell.colorView.backgroundColor = self.dayColors[date]?.backgroundColor
        cell.colorView.clipsToBounds = true
        cell.colorView.layer.cornerRadius = cell.colorView.width() / 2
        
        return cell
    }

    
    func setUpCalendarConfiguration() {
        self.calendarView.calendarDelegate = self
        
        // Set displayed period type. Available types: Month, ThreeWeeks, TwoWeeks, OneWeek
        self.calendarView.configuration.periodType = .Month
        
        // Set shape of day view. Available types: Circle, Square
        self.calendarView.configuration.dayViewType = .Circle
        
        // Set selected day display type. Available types:
        // Border - Only border is colored with selected day color
        // Filled - Entire day view is filled with selected day color
        self.calendarView.configuration.selectedDayType = .Border
        
        // Set width of selected day border. Relevant only if selectedDayType = .Border
        self.calendarView.configuration.selectedBorderWidth = 1
        
        // Set day text color
        self.calendarView.configuration.dayTextColor = UIColor(netHex: 0x6F787C)
        
        // Set day background color
        self.calendarView.configuration.dayBackgroundColor = UIColor(netHex: 0xF0F0F0)
        
        // Set selected day text color
        self.calendarView.configuration.selectedDayTextColor = UIColor.whiteColor()
        
        // Set selected day background color
        self.calendarView.configuration.selectedDayBackgroundColor = UIColor(netHex: 0x6F787C)
        
        // Set other month day text color. Relevant only if periodType = .Month
        self.calendarView.configuration.otherMonthTextColor = UIColor(netHex: 0x6F787C)
        
        // Set other month background color. Relevant only if periodType = .Month
        self.calendarView.configuration.otherMonthBackgroundColor = UIColor(netHex: 0xE7E7E7)
        
        // Set week text color
        self.calendarView.configuration.weekLabelTextColor = UIColor(netHex: 0x6F787C)
        
        // Set start day. Available type: .Monday, Sunday
        //self.calendarView.configuration.startDayType = .Monday
        self.calendarView.configuration.startDayType = .Sunday
        
        // Set day text font
        self.calendarView.configuration.dayTextFont = UIFont.systemFontOfSize(12)
        
        //Set week's day name font
        self.calendarView.configuration.weekLabelFont = UIFont.systemFontOfSize(12)
        
        //Set day view size. It includes border width if selectedDayType = .Border
        self.calendarView.configuration.dayViewSize = CGSizeMake(24, 24)
        
        //Set height of row with week's days
        self.calendarView.configuration.rowHeight = 30
        
        // Set height of week's days names view
        self.calendarView.configuration.weekLabelHeight = 25
        
        // To commit all configuration changes execute reloadView method
        self.calendarView.reloadView()
    }
    
    func setTitleWithDate(date: NSDate) {
        self.dateFormatter.dateFormat = "MMMM yy"
        self.navigationItem.title = self.dateFormatter.stringFromDate(date)
    }
    
    func setUpDays() {
        for i in 0...self.daysRange {
            let day = self.dateByIndex(i)
            if let randColor = self.randColor() {
                let dayColors = DayColors(backgroundColor: randColor, textColor: UIColor.whiteColor())
                self.dayColors[day] = dayColors
            } else {
                self.dayColors[day] = nil
            }
        }
    }
    
    func randColor() -> UIColor? {
        if rand() % 2 == 0 {
            let colorIndex = Int(rand()) % self.colors.count
            let color = self.colors[colorIndex]
            return color
        }
        
        return nil
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Prevent changing selected day when non user scroll is triggered.
        if !self.isScrollingAnimation {
            // Get all visible cells from tableview
            if let visibleCells = self.tableView.indexPathsForVisibleRows {
                if let cellIndexPath = visibleCells.first {
                    // Get day by indexPath
                    let day = self.dateByIndex(cellIndexPath.row)
                    
                    //Select day according to first visible cell in tableview
                    self.calendarView.selectDate(day)
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.isScrollingAnimation = false
    }
    
    func dateByIndex(index: Int) -> NSDate {
        let startDay = NSDate().dateAtStartOfDay().dateBySubtractingDays(self.daysRange / 2)
        let day = startDay.dateByAddingDays(index)
        return day
    }
    
    func scrollTableViewToDate(date: NSDate) {
        if let row = self.indexByDate(date) {
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
            self.isScrollingAnimation = true
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
    }
    
    func indexByDate(date: NSDate) -> Int? {
        let startDay = NSDate().dateAtStartOfDay().dateBySubtractingDays(self.daysRange / 2)
        let index = date.daysAfterDate(startDay)
        if index >= 0 && index <= self.daysRange {
            return index
        } else {
            return nil
        }
    }
    
    //MARK: MJCalendarViewDelegate
    func calendar(calendarView: MJCalendarView, didChangePeriod periodDate: NSDate, bySwipe: Bool) {
        // Sets month name according to presented dates
        self.setTitleWithDate(periodDate)
        
        // bySwipe diffrentiate changes made from swipes or select date method
        if bySwipe {
            // Scroll to relevant date in tableview
            self.scrollTableViewToDate(periodDate)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func calendar(calendarView: MJCalendarView, backgroundForDate date: NSDate) -> UIColor? {
        return self.dayColors[date]?.backgroundColor
    }
    
    func calendar(calendarView: MJCalendarView, textColorForDate date: NSDate) -> UIColor? {
        return self.dayColors[date]?.textColor
    }
    
    func calendar(calendarView: MJCalendarView, didSelectDate date: NSDate) {
        self.scrollTableViewToDate(date)
    }
    
    //MARK: Toolbar actions
    @IBAction func didTapMonth(sender: AnyObject) {
        self.animateToPeriod(.Month)
    }
    
    @IBAction func didTapThreeWeeks(sender: AnyObject) {
        self.animateToPeriod(.ThreeWeeks)
    }
    
    @IBAction func didTapTwoWeeks(sender: AnyObject) {
        self.animateToPeriod(.TwoWeeks)
    }
    
    @IBAction func didTapOneWeek(sender: AnyObject) {
        self.animateToPeriod(.OneWeek)
    }
    
    func animateToPeriod(period: MJConfiguration.PeriodType) {
        self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
        
        self.calendarView.animateToPeriodType(period, duration: 0.2, animations: { (calendarHeight) -> Void in
            // In animation block you can add your own animation. To adapat UI to new calendar height you can use calendarHeight param
            self.calendarViewHeight.constant = calendarHeight
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
