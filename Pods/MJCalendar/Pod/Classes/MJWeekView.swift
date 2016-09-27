//
//  WeekView.swift
//  Pods
//
//  Created by Michał Jackowski on 21.09.2015.
//
//

import UIKit
import NSDate_Escort

public class MJWeekView: MJComponentView {
    var date: NSDate! {
        didSet {
            self.configureViews()
        }
    }
    var days: [MJDayView]?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(date: NSDate, delegate: MJComponentDelegate) {
        self.date = date
        super.init(delegate: delegate)
        self.configureViews()
    }
    
    func configureViews() {
        if let dayViews = self.days {
            for i in 1...7 {
                let dayDate = self.date!.self.dateByAddingDays(i-1)
                dayViews[i - 1].date = dayDate
            }
        } else {
            self.days = []
            for i in 1...7 {
                let dayDate = self.date!.self.dateByAddingDays(i-1)
                let dayView = MJDayView(date: dayDate, delegate: self.delegate!)
                self.addSubview(dayView)
                self.days!.append(dayView)
            }
        }
    }
    
    override func updateFrame() {
        for (index, day) in (self.days!).enumerate() {
            let dayWidth = self.width() / 7
            day.frame = CGRectMake(CGFloat(index) * dayWidth, 0, dayWidth, self.height())
        }
    }
}
