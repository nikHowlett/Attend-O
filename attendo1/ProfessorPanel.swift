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
    
    @IBAction func signOut(sender: AnyObject) {
        
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
            let alert = UIAlertView()
            alert.title = "Signing Out"
            alert.message = "You have successfully signed out."
            alert.addButtonWithTitle("Ok")
            alert.show()
            print("test")
    }
}