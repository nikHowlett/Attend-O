//
//  MJCalendarView.swift
//  Pods
//
//  Created by Michał Jackowski on 18.09.2015.
//
//

import UIKit
import NSDate_Escort
import UIView_JMFrame

public protocol MJCalendarViewDelegate: NSObjectProtocol {
    func calendar(calendarView: MJCalendarView, didChangePeriod periodDate: NSDate, bySwipe: Bool)
    func calendar(calendarView: MJCalendarView, didSelectDate date: NSDate)
    func calendar(calendarView: MJCalendarView, backgroundForDate date: NSDate) -> UIColor?
    func calendar(calendarView: MJCalendarView, textColorForDate date: NSDate) -> UIColor?
}

public class MJCalendarView: UIView, UIScrollViewDelegate, MJComponentDelegate {
    public var configuration: MJConfiguration
    var periods: [MJPeriodView]?
    var weekLabelsView: MJWeekLabelsView?
    var periodsContainerView: UIScrollView?
    
    var date: NSDate
    var visiblePeriodDate: NSDate!
    var currentFrame = CGRectZero
    weak public var calendarDelegate: MJCalendarViewDelegate?
    var isAnimating = false
    
    var currentPage: Int!
    
    required public init?(coder aDecoder: NSCoder) {
        self.configuration = MJConfiguration.getDefault()
        self.date = NSDate().dateAtStartOfDay()
        super.init(coder: aDecoder)
        self.visiblePeriodDate = self.startDate(self.date, withOtherMonth: false)
        self.configureViews()
    }
    
    override init(frame: CGRect) {
        self.configuration = MJConfiguration.getDefault()
        self.date = NSDate().dateAtStartOfDay()
        super.init(frame: frame)
        self.visiblePeriodDate = self.startDate(self.date, withOtherMonth: false)
        self.configureViews()
    }
    
    func configureViews() {
        self.weekLabelsView = MJWeekLabelsView(delegate: self)
        self.addSubview(self.weekLabelsView!)
        
        self.periodsContainerView = UIScrollView(frame: CGRectZero)
        self.periodsContainerView!.pagingEnabled = true
        self.periodsContainerView!.delegate = self
        self.periodsContainerView?.showsHorizontalScrollIndicator = false
        self.addSubview(self.periodsContainerView!)
        
        self.setPeriodViews()
    }
    
    func setPeriodViews() {
        let visibleDate = self.visiblePeriodDate
        let previousDate = self.previousPeriodDate(visibleDate, withOtherMonth: true)
        let currentDate = self.startDate(visibleDate, withOtherMonth: true)
        let nextDate = self.nextPeriodDate(visibleDate, withOtherMonth: true)
        
        if var periodViews = self.periods {
            if self.shouldChangePeriodsRange() {
                if self.periods?.count == 3 {
                    periodViews[0].date = previousDate
                    periodViews[1].date = currentDate
                    periodViews[2].date = nextDate
                    
                    self.currentPage = 1
                    self.setPeriodFrames()
                } else {
                    self.createPeriodsViews(previousDate, currentDate: currentDate, nextDate: nextDate)
                    self.setPeriodFrames()
                }
            } else {
                for periodView in periodViews {
                    periodView.configureViews()
                }
            }
        } else {
            self.createPeriodsViews(previousDate, currentDate: currentDate, nextDate: nextDate)
        }
    }
    
    func createPeriodsViews(previousDate: NSDate, currentDate: NSDate, nextDate: NSDate) {
        self.clearView()
        self.periods = []
        
        let previosPeriodView = MJPeriodView(date: previousDate, delegate: self)
        if !isDateEarlierThanMin(previosPeriodView.endingPeriodDate()) {
            self.periodsContainerView!.addSubview(previosPeriodView)
            self.periods!.append(previosPeriodView)
        }
        
        let currentPeriodView = MJPeriodView(date: currentDate, delegate: self)
        self.periodsContainerView!.addSubview(currentPeriodView)
        self.periods!.append(currentPeriodView)
        
        let nextPeriodView = MJPeriodView(date: nextDate, delegate: self)
        if !isDateLaterThanMax(nextPeriodView.startingPeriodDate()) {
            self.periodsContainerView!.addSubview(nextPeriodView)
            self.periods!.append(nextPeriodView)
        }
        
        self.currentPage = self.periods!.indexOf(currentPeriodView)
    }
    
    func shouldChangePeriodsRange() -> Bool {
        let startDateOfPeriod = self.visiblePeriodDate
        let endDateOfPeriod = nextPeriodDate(self.visiblePeriodDate, withOtherMonth: false)
        return !(self.isDateEarlierThanMin(startDateOfPeriod) || self.isDateLaterThanMax(endDateOfPeriod))
    }
    
    func isDateEarlierThanMin(date: NSDate) -> Bool {
        if let minDate = configuration.minDate?.dateAtStartOfDay() {
            if date.isEarlierThanDate(minDate) {
                return true
            }
        }
        
        return false
    }
    
    func isDateLaterThanMax(date: NSDate) -> Bool {
        if let maxDate = configuration.maxDate?.dateAtEndOfDay() {
            if date.isLaterThanDate(maxDate) {
                return true
            }
        }
        
        return false
    }
    
    override public func layoutSubviews() {
        if !CGRectEqualToRect(self.currentFrame, self.frame) && !isAnimating {
            self.currentFrame = self.frame
            
            let weekLabelsViewHeight = self.configuration.weekLabelHeight
            self.periodsContainerView!.frame = CGRectMake(0, weekLabelsViewHeight, self.width(), self.height() - weekLabelsViewHeight)
            
            self.setPeriodFrames()
        }
    }
    
    func setPeriodFrames() {
        let mod7 = self.width() % 7
        let width = self.width() - mod7
        let x = ceil(mod7 / 2)
        
        self.weekLabelsView?.frame = CGRectMake(x, 0, width, self.configuration.weekLabelHeight)
        
        for (index, period) in (self.periods!).enumerate() {
            period.frame = CGRectMake(CGFloat(index) * self.width() + x, 0, width, self.periodHeight(self.configuration.periodType))
        }
        
        self.periodsContainerView!.contentSize = CGSizeMake(self.width() * CGFloat(self.periods!.count), self.height() - self.configuration.weekLabelHeight)
        self.periodsContainerView!.contentOffset.x = CGRectGetWidth(self.frame) * CGFloat(self.currentPage)
    }
    
    func periodHeight(periodType: MJConfiguration.PeriodType) -> CGFloat {
        return CGFloat(periodType.weeksCount()) * self.configuration.rowHeight
    }
    
    func startDate(date: NSDate, withOtherMonth: Bool) -> NSDate {
        if self.configuration.periodType == .Month {
            let beginningOfMonth = date.dateAtStartOfMonth()
            if withOtherMonth {
                return self.startWeekDay(beginningOfMonth)
            } else {
                return beginningOfMonth
            }
            
        } else {
            return self.startWeekDay(date)
        }
    }
    
    func startWeekDay(date: NSDate) -> NSDate {
        let delta = self.configuration.startDayType == .Monday ? 2 : 1
        var daysToSubstract = date.weekday - delta
        if daysToSubstract < 0 {
            daysToSubstract += 7
        }
        return date.dateBySubtractingDays(daysToSubstract)
    }
    
    func nextPeriodDate(date: NSDate, withOtherMonth: Bool) -> NSDate {
        return self.periodDate(date, isNext: true, withOtherMonth: withOtherMonth)
    }
    
    func previousPeriodDate(date: NSDate, withOtherMonth: Bool) -> NSDate {
        return self.periodDate(date, isNext: false, withOtherMonth: withOtherMonth)
    }
    
    func periodDate(date: NSDate, isNext: Bool, withOtherMonth: Bool) -> NSDate {
        let isNextFactor = isNext ? 1 : -1
        switch self.configuration.periodType {
            case .Month:
                let otherMonthDate = date.dateByAddingMonths(1 * isNextFactor)
                return self.startDate(otherMonthDate, withOtherMonth: withOtherMonth)
            case .ThreeWeeks: return date.dateByAddingDays((3 * isNextFactor) * 7)
            case .TwoWeeks: return date.dateByAddingDays((2 * isNextFactor) * 7)
            case .OneWeek: return date.dateByAddingDays((1 * isNextFactor) * 7)
        }
    }
    
    public func selectDate(date: NSDate) {
        let validatedDate = dateInRange(date)
        if !self.isDateAlreadyShown(validatedDate) {
            let periodDate = self.startDate(validatedDate, withOtherMonth: false)
            self.visiblePeriodDate = validatedDate.timeIntervalSince1970 < self.date.timeIntervalSince1970
                ? self.retroPeriodDate(periodDate) : periodDate
            self.calendarDelegate?.calendar(self, didChangePeriod: periodDate, bySwipe: false)
        }
        self.date = validatedDate
        self.setPeriodViews()
    }
    
    func dateInRange(date: NSDate) -> NSDate {
        if isDateEarlierThanMin(date) {
            return configuration.minDate!.dateAtStartOfDay()
        } else {
            return date
        }
    }
    
    func retroPeriodDate(periodDate: NSDate) -> NSDate {
        switch self.configuration.periodType {
            case .Month: return periodDate
            case .ThreeWeeks: return periodDate.dateByAddingDays(-14)
            case .TwoWeeks: return periodDate.dateByAddingDays(-7)
            case .OneWeek: return periodDate
        }
    }
    
    func currentPeriod() -> MJPeriodView {
        return self.periods![self.currentPage]
    }
    
    func isDateAlreadyShown(date: NSDate) -> Bool {
        if self.configuration.periodType == .Month {
            return date.dateAtStartOfMonth() == self.visiblePeriodDate.dateAtStartOfMonth()
        } else {
            return date.timeIntervalSince1970 >= self.currentPeriod().startingDate().timeIntervalSince1970
                &&  date.timeIntervalSince1970 <= self.currentPeriod().endingDate().timeIntervalSince1970
        }
    }
    
    // MARK: Calendar delegate
    
    func componentView(componentView: MJComponentView, isDateSelected date: NSDate) -> Bool {
        return self.date == date
    }
    
    func configurationWithComponent(componentView: MJComponentView) -> MJConfiguration {
        return self.configuration
    }
    
    func componentView(componentView: MJComponentView, didSelectDate date: NSDate) {
        self.selectDate(date)
        self.calendarDelegate?.calendar(self, didSelectDate: date)
    }
    
    func isBeingAnimatedWithComponentView(componentView: MJComponentView) -> Bool {
        return self.isAnimating
    }
    
    func componentView(componentView: MJComponentView, backgroundColorForDate date: NSDate) -> UIColor? {
        return self.calendarDelegate?.calendar(self, backgroundForDate: date)
    }
    
    func componentView(componentView: MJComponentView, textColorForDate date: NSDate) -> UIColor? {
        return self.calendarDelegate?.calendar(self, textColorForDate: date)
    }
    
    func isDateOutOfRange(componentView: MJComponentView, date: NSDate) -> Bool {
        return isDateLaterThanMax(date) || isDateEarlierThanMin(date)
    }
    
    // MARK: UIScrollViewDelegate
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageWidth = CGRectGetWidth(scrollView.frame)
        let ratio = scrollView.contentOffset.x / pageWidth
        let page = Int(ratio)

        let periodDate = self.periodDateFromPage(page)
        if self.visiblePeriodDate !=  periodDate {
            self.currentPage = page
            self.visiblePeriodDate = periodDate
            self.calendarDelegate?.calendar(self, didChangePeriod: periodDate, bySwipe: true)
            if self.configuration.selectDayOnPeriodChange {
                self.selectDate(periodDate)
            } else {
                self.setPeriodViews()
            }
        }
    }
    
    func periodDateFromPage(page: Int) -> NSDate {
        return periods![page].startingPeriodDate()
    }
    
    public func reloadView() {
        self.visiblePeriodDate = self.recalculatedVisibleDate(false)
        self.clearView()
        self.setPeriodViews()
        self.setPeriodFrames()
        self.weekLabelsView?.updateView()
    }
    
    func clearView() {
        if let periodViews = self.periods {
            for period in periodViews {
                period.removeFromSuperview()
            }
        }
        
        self.periods = nil
        self.currentFrame = CGRectZero
    }
    
    func recalculatedVisibleDate(withOtherMonth: Bool) -> NSDate {
        let visibleDate = self.currentPeriod().isDateInPeriod(self.date) ? self.date : self.visiblePeriodDate
        let startDate = self.startDate(visibleDate, withOtherMonth: withOtherMonth)
        if self.configuration.periodType == .Month || self.configuration.periodType == .OneWeek {
            return startDate
        } else {
            let weekIndex = self.weekIndexByStartDate(startDate) + 1
            let weekCount = self.configuration.periodType.weeksCount()
            let visibleIndex = weekIndex - weekCount > 0 ? weekIndex - weekCount : 0
            return self.currentPeriod().weeks![visibleIndex].date
        }
    }
    
    func weekIndexByStartDate(startDate: NSDate) -> Int {
        for (index, week) in (self.currentPeriod().weeks!).enumerate() {
            if week.date == startDate {
                return index
            }
        }
        
        return 0
    }
    
    public func reloadDayViews() {
        for periodView in self.periods! {
            for weekView in periodView.weeks! {
                for dayView in weekView.days! {
                    dayView.updateView()
                }
            }
        }
    }
    
    public func animateToPeriodType(periodType: MJConfiguration.PeriodType, duration: NSTimeInterval, animations: (calendarHeight: CGFloat) -> Void, completion: ((Bool) -> Void)?) {
        let previousVisibleDate = self.visiblePeriodDate
        let previousPeriodType = self.configuration.periodType
        
        self.configuration.periodType = periodType
        let yDelta = self.periodYDelta(periodType, previousVisibleDate: previousVisibleDate)
        
        if periodType.weeksCount() > previousPeriodType.weeksCount() {
            self.reloadView()
            self.layoutIfNeeded()
            
            self.currentPeriod().setY(self.currentPeriod().y() + yDelta)
            self.currentPeriod().setHeight(self.periodHeight(previousPeriodType) - yDelta)
            
            self.performAnimation(true, periodType: periodType, yDelta: yDelta, duration: duration, animations: animations, completion: completion)
        } else {
            self.performAnimation(false, periodType: periodType, yDelta: yDelta, duration: duration, animations: animations, completion: completion)
        }
    }
    
    func periodYDelta(periodType: MJConfiguration.PeriodType, previousVisibleDate: NSDate) -> CGFloat {
        let visiblePeriodDatePreview = self.recalculatedVisibleDate(true)
        let deltaVisiblePeriod = visiblePeriodDatePreview.timeIntervalSince1970 - previousVisibleDate.timeIntervalSince1970
        let weekIndexDelta = ceil(deltaVisiblePeriod / (3600 * 24 * 7))
        return CGFloat(weekIndexDelta) * self.configuration.rowHeight
    }
    
    func performAnimation(animateToBiggerSize: Bool, periodType: MJConfiguration.PeriodType, yDelta: CGFloat, duration: NSTimeInterval, animations: (calendarHeight: CGFloat) -> Void, completion: ((Bool) -> Void)?) {
        self.isAnimating = true
        UIView.animateWithDuration(duration, animations: { () -> Void in
            animations(calendarHeight: self.periodHeight(periodType) + self.configuration.weekLabelHeight)
            if animateToBiggerSize {
                self.currentPeriod().setY(0)
                self.currentPeriod().setHeight(self.periodHeight(periodType))
            } else {
                self.currentPeriod().setY(self.currentPeriod().y() - yDelta)
                self.currentPeriod().setHeight(self.periodHeight(periodType) + yDelta)
            }
            
            }) { (completed) -> Void in
                self.isAnimating = false
                if !animateToBiggerSize {
                    self.reloadView()
                    self.setPeriodFrames()
                }
                self.calendarDelegate?.calendar(self, didChangePeriod: self.visiblePeriodDate, bySwipe: false)
                
                if let completionBlock = completion {
                    completionBlock(completed)
                }
        }
    }
}
