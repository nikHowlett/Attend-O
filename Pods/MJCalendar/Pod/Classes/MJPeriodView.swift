//
//  PeriodView.swift
//  Pods
//
//  Created by Michał Jackowski on 21.09.2015.
//
//

import UIKit
import NSDate_Escort

public class MJPeriodView: MJComponentView {
    var date: NSDate! {
        didSet {
            self.configureViews()
        }
    }
    var weeks: [MJWeekView]?
    var numberOfWeeks: Int {
        return self.delegate!.configurationWithComponent(self).periodType.weeksCount()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(date: NSDate, delegate: MJComponentDelegate) {
        self.date = date
        super.init(delegate: delegate)
        self.clipsToBounds = true
        self.configureViews()
    }
    
    func configureViews() {
        if let weekViews = self.weeks {
            for i in 1...self.numberOfWeeks {
                let weekDate = self.date!.self.dateByAddingDays((i-1) * 7)
                weekViews[i - 1].date = weekDate
            }
        } else {
            self.weeks = []
            for i in 1...self.numberOfWeeks {
                let weekDate = self.date!.self.dateByAddingDays((i-1) * 7)
                let weekView = MJWeekView(date: weekDate, delegate: self.delegate!)
                self.addSubview(weekView)
                self.weeks!.append(weekView)
            }
        }
        
        self.setIsSameMonth()
    }
    
    func setIsSameMonth() {
        if (self.delegate.configurationWithComponent(self).periodType == .Month) {
            let monthDate = self.weeks![1].date
            for (index, week) in (self.weeks!).enumerate() {
                if index == 0 || index == 4 || index == 5 {
                    for dayView in week.days! {
                        dayView.isSameMonth = dayView.date.dateAtStartOfMonth() == monthDate.dateAtStartOfMonth()
                    }
                }
            }
        }
    }
    
    override func updateFrame() {
        for (index, week) in (self.weeks!).enumerate() {
            let lineHeight = self.delegate.configurationWithComponent(self).rowHeight
            week.frame = CGRectMake(0, CGFloat(index) * lineHeight, self.width(), lineHeight)
        }
    }
    
    public func startingDate() -> NSDate {
        return self.weeks!.first!.days!.first!.date!
    }
    
    public func endingDate() -> NSDate {
        return self.weeks!.last!.days!.last!.date!
    }
    
    public func startingPeriodDate() -> NSDate {
        let monthCount = MJConfiguration.PeriodType.Month.weeksCount()
        if self.weeks?.count == monthCount {
            let middleDate = self.weeks![3].date
            return middleDate.dateAtStartOfMonth()
        } else {
            return startingDate()
        }
    }
    
    public func endingPeriodDate() -> NSDate {
        let monthCount = MJConfiguration.PeriodType.Month.weeksCount()
        if self.weeks?.count == monthCount {
            let middleDate = self.weeks![3].date
            return middleDate.dateAtEndOfMonth()
        } else {
            return endingDate()
        }
    }
    
    public func isDateInPeriod(date: NSDate) -> Bool {
        return date.isLaterThanOrEqualDate(startingPeriodDate()) && date.isEarlierThanOrEqualDate(endingPeriodDate())
    }
}
