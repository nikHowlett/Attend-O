//
//  secondViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 4/8/16.
//  Copyright © 2016 NikHowlett. All rights reserved.
//

import UIKit
import NSDate_Escort
import MJCalendar
import HexColors

class secondViewController: UIViewController, MJCalendarViewDelegate {
    
    @IBOutlet weak var classLabel: UILabel!
    
    var toPass = "CS 1330"
    
    var tdate = "Apfil 16"

    @IBOutlet weak var whichDate: UILabel!
    
    @IBOutlet weak var calendarView: MJCalendarView!
    
    @IBOutlet weak var monthNameLabel: UILabel!
    
    @IBOutlet weak var viewData: UIButton!
    
    var selected = false
    
    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    
    var dayColors = Dictionary<NSDate, DayColors>()
    
    var colors: [UIColor] {
        return [
            UIColor(netHex: 0xF6980B),
            UIColor(netHex: 0x2081D9),
            UIColor(netHex: 0x2FBD8F),
            //UIColor(netHex:0xFFFFFF)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCalendarConfiguration()
        self.setTitleWithDate(NSDate())
        classLabel.text = toPass
        viewData.hidden = true
        self.title = "Pick a Day"
        //self.animateToPeriod(.OneWeek)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.calendarView.configuration.selectedDayType = .Filled
        
        // Set day text color
        self.calendarView.configuration.dayTextColor = UIColor(netHex: 0x6f787c)
        //self.calendarView.configuration.dayTextColor = UIColor(hexString: "6f787c")
        
        // Set day background color
        self.calendarView.configuration.dayBackgroundColor = UIColor(netHex: 0xf0f0f0)
        
        // Set selected day text color
        self.calendarView.configuration.selectedDayTextColor = UIColor.whiteColor()
        
        // Set selected day background color
        self.calendarView.configuration.selectedDayBackgroundColor = UIColor(netHex: 0x2FBD8F)
        
        // Set other month day text color. Relevant only if periodType = .Month
        self.calendarView.configuration.otherMonthTextColor = UIColor(netHex: 0x6f787c)
        
        // Set other month background color. Relevant only if periodType = .Month
        self.calendarView.configuration.otherMonthBackgroundColor = UIColor(netHex: 0xE7E7E7)
        
        // Set week text color
        self.calendarView.configuration.weekLabelTextColor = UIColor(netHex: 0x6f787c)
        
        // Set start day. Available type: .Monday, Sunday
        self.calendarView.configuration.startDayType = .Monday
        
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
        
        
        //Set min date
        self.calendarView.configuration.minDate = NSDate().dateBySubtractingDays(60)
        
        
        //Set max date
        self.calendarView.configuration.maxDate = NSDate().dateByAddingDays(60)
        
        self.calendarView.configuration.outOfRangeDayBackgroundColor = UIColor(netHex: 0xE7E7E7)
        self.calendarView.configuration.outOfRangeDayTextColor = UIColor(netHex: 0x6f787c)
        
        self.calendarView.configuration.selectDayOnPeriodChange = false
        
        // To commit all configuration changes execute reloadView method
        self.calendarView.reloadView()
    }
    
    func setTitleWithDate(date: NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM yy"
        self.monthNameLabel.text = dateFormatter.stringFromDate(date)
    }
    
    //MARK: MJCalendarViewDelegate
    func calendar(calendarView: MJCalendarView, didChangePeriod periodDate: NSDate, bySwipe: Bool) {
        // Sets month name according to presented dates
        self.setTitleWithDate(periodDate)
    }
    
    func calendar(calendarView: MJCalendarView, backgroundForDate date: NSDate) -> UIColor? {
        return nil
    }
    
    func calendar(calendarView: MJCalendarView, textColorForDate date: NSDate) -> UIColor? {
        return nil
    }
    
    func calendar(calendarView: MJCalendarView, didSelectDate date: NSDate) {
        viewData.hidden = false
        print(date)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        //dateFormatter.dateFormat = "MM-dd"
        whichDate.text = dateFormatter.stringFromDate(date)
        tdate = whichDate.text!
        /* 
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM yy"
        self.monthNameLabel.text = dateFormatter.stringFromDate(date)

        */
        
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
        self.calendarView.animateToPeriodType(period, duration: 0.2, animations: { (calendarHeight) -> Void in
            // In animation block you can add your own animation. To adapat UI to new calendar height you can use calendarHeight param
            self.calendarViewHeight.constant = calendarHeight
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "choseADate") {
            let svc = segue.destinationViewController as! viewStudentViewController;
            
            svc.toPass = toPass
            svc.tdate = tdate
            
        }
    }
    
    @IBAction func viewData(sender: AnyObject) {
        self.performSegueWithIdentifier("choseADate", sender: self)
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
