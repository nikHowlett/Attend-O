//
//  MJConfiguration.swift
//  Pods
//
//  Created by Michał Jackowski on 18.09.2015.
//
//

import Foundation

public struct MJConfiguration {
    public enum PeriodType {
        case OneWeek, TwoWeeks, ThreeWeeks, Month
        func weeksCount() -> Int {
            switch self {
                case .Month: return 6
                case .ThreeWeeks: return 3
                case .TwoWeeks: return 2
                case .OneWeek: return 1
            }
        }
    }
    
    public enum DayViewType {
        case Square, Circle
    }
    
    public enum StartDayType {
        case Monday, Sunday
    }
    
    public enum SelectedDayType {
        case Filled, Border
    }
    
    public var periodType: PeriodType = .Month
    public var dayViewType: DayViewType = .Circle
    public var startDayType: StartDayType = .Monday
    public var selectedDayType: SelectedDayType = .Border
    
    public var rowHeight: CGFloat = 30
    public var dayViewSize: CGSize = CGSizeMake(24, 24)
    public var dayTextFont = UIFont.systemFontOfSize(12)
    
    public var otherMonthBackgroundColor = UIColor.clearColor()
    public var otherMonthDayViewBackgroundColor = UIColor.clearColor()
    public var otherMonthTextColor = UIColor.clearColor()
    
    public var dayBackgroundColor = UIColor.clearColor()
    public var dayDayViewBackgroundColor = UIColor.clearColor()
    public var dayTextColor = UIColor.clearColor()
    
    public var selectedDayBackgroundColor = UIColor.clearColor()
    public var selectedDayTextColor = UIColor.clearColor()
    public var selectedBorderWidth: CGFloat = 1
    
    public var weekLabelFont = UIFont.systemFontOfSize(12)
    public var weekLabelTextColor = UIColor.clearColor()
    public var weekLabelHeight: CGFloat = 25
    
    public var minDate: NSDate?
    public var maxDate: NSDate?
    
    public var outOfRangeDayBackgroundColor = UIColor.clearColor()
    public var outOfRangeDayTextColor = UIColor.clearColor()
    
    public var selectDayOnPeriodChange: Bool = true
    
    static func getDefault() -> MJConfiguration {
        let configuration = MJConfiguration()
        return configuration
    }
}
