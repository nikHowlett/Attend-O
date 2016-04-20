//
//  ProfessorPanel.swift
//  attendo1
//
//  Created by Nik Howlett on 11/7/15.
//  Copyright (c) 2015 NikHowlett. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import QuartzCore

class ProfessorPanel: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var editClassesButton: UIButton!
    
    @IBOutlet weak var addClassesButton: UIButton!
    
    @IBOutlet weak var classPicker: UIPickerView!
    
    var pickerSelectedClassName: String = String()
    
    var curRow: Int = Int()
    
    var pickerSelectedClassDate: NSDate = NSDate()
    
    //var pickerSelectedClassObj: NSManagedObject = NSManagedObject()
    
    var backupData: [String] = [String]()
    
    var classes : [Class2] = [Class2]()
    
    @IBOutlet weak var string: UILabel!
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedContext : NSManagedObjectContext? = appDelegate.managedObjectContext {
            return managedContext
        } else {
            return nil
        }
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "Class2")
        let error: NSError? = nil
        do { classes = try managedObjectContext?.executeFetchRequest(fetchRequest) as! [Class2] } catch _ as NSError { print("An error occurred loading the data") }
        if error != nil {
            print("An error occurred loading the data")
        }
        if classes.isEmpty {
            backupData = ["CS 2340", "CS 3750"];
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if classes.count > 0 {
            return classes.count
        } else {
            return backupData.count
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func SelectThisClass(sender: AnyObject) {
        performSegueWithIdentifier("selectClass", sender: self)
    }
    
    @IBAction func addClassButt(sender: AnyObject) {
        somehowAddClass()
    }
    
    func somehowAddClass() {
        performSegueWithIdentifier("addClass", sender: self)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if classes.count > 0 {
            pickerSelectedClassName = classes[row].courseName
            pickerSelectedClassDate = classes[row].startTime
            curRow = row
            //pickerSelectedClassObj = classes[row]
            return classes[row].courseName
        } else {
            return backupData[row]
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if classes.count > 0 {
            string.text = classes[row].courseName
        } else {
            string.text = backupData[row]
        }
    }
    
    @IBAction func editClassButtPress(sender: AnyObject) {
        performSegueWithIdentifier("editClass", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "editClass") {
            let svc = segue.destinationViewController as! EditViewController
            svc.classNameSent = pickerSelectedClassName
            svc.dateTimeSent = pickerSelectedClassDate
            //svc.classObjSent = pickerSelectedClassObj
            //svc.classObjSent = (classes[curRow] as? NSManagedObject)!
        }
        if (segue.identifier == "selectClass") {
            let svc = segue.destinationViewController as! SelectClassViewController
            svc.classNameSent = pickerSelectedClassName
            svc.dateTimeSent = pickerSelectedClassDate
            //svc.classObjSent = classes[curRow]
        }
    }
    
    @IBAction func Logout9(sender: AnyObject) {
        /*if #available(iOS 9.0, *) {
            //self.navigationController?.popToViewController((ViewController.self as? UIViewController)!, animated: true)
            self.navigationController?.popToRootViewControllerAnimated(true)
            self.navigationController?.popToViewController(viewControllerForUnwindSegueAction("logout9", fromViewController: ProfessorPanel, withSender: self), animated: true)
        }*/
        
    }
    
    /*@IBAction func unwindToVC(segue: UIStoryboardSegue) {
            /*let alert = UIAlertView()
            alert.title = "Signing Out"
            alert.message = "You have successfully signed out."
            alert.addButtonWithTitle("Ok")
            alert.show()
            print("test")*/
        if let redViewController = segue.sourceViewController as? ProfessorPanel {
            print("Coming from RED")
        }
    }*/
}