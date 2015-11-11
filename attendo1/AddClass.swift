//
//  AddClass.swift
//  attendo1
//
//  Created by Nik Howlett on 11/7/15.
//  Copyright (c) 2015 NikHowlett. All rights reserved.
//

import Foundation
import UIKit
import UIKit
import CoreData
import QuartzCore

class AddClass: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Class"
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            managedObjectContext = appDelegate.managedObjectContext
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    @IBOutlet weak var nextPage: UIButton!
    
    @IBOutlet weak var nameOutlet: UITextField!
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedContext : NSManagedObjectContext? = appDelegate.managedObjectContext {
            return managedContext
        } else {
            return nil
        }
    }()
    
    private func saveClass(name: String, tempstartTime: NSDate) {
        if managedObjectContext != nil {
            if let entity = NSEntityDescription.entityForName("Class2", inManagedObjectContext: managedObjectContext!) {
                let ucb = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedObjectContext!) as! Class2
                ucb.courseName = name
                ucb.startTime = tempstartTime
                var error: NSError? = nil
                do {
                    try managedObjectContext!.save()
                } catch var error1 as NSError {
                    error = error1
                    print("Could not save \(error), \(error?.userInfo)")
                }
                performSegueWithIdentifier("backToClass", sender: self)
            }
            
        } else {
            print("Could not get managed object context")
        }
    }
    
    @IBAction func addClass(sender: AnyObject) {
        if nameOutlet.hasText() {
            self.saveClass(nameOutlet.text!, tempstartTime: datePicker.date)
            scheduleLocalNotification()
        } else {
            let alert = UIAlertView(title: "Invalid Class Name", message: "Please enter a valid class name.", delegate: self, cancelButtonTitle:"Dismiss")
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    func scheduleLocalNotification() {
        let localNotification = UILocalNotification()
        localNotification.soundName = "beep-01a.wav"
        if #available(iOS 8.2, *) {
            localNotification.alertTitle = "Take Attendance!"
        } else {
            // Fallback on earlier versions
        }
        localNotification.alertBody = "Class is starting, time to take attendance!"
        localNotification.alertAction = "Generate QR"
        if #available(iOS 8.0, *) {
            localNotification.category = "classCategory"
        } else {
            // Fallback on earlier versions
        }
        print(datePicker.date)
        localNotification.fireDate = datePicker.date
        localNotification.repeatInterval = .Day
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func fixNotificationDate(dateToFix: NSDate) -> NSDate {
        let dateComponets: NSDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.NSDayCalendarUnit, NSCalendarUnit.NSMonthCalendarUnit, NSCalendarUnit.NSYearCalendarUnit, NSCalendarUnit.NSHourCalendarUnit, NSCalendarUnit.NSMinuteCalendarUnit], fromDate: dateToFix)
        
        dateComponets.second = 0
        
        let fixedDate: NSDate! = NSCalendar.currentCalendar().dateFromComponents(dateComponets)
        print(fixedDate)
        return fixedDate
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}
