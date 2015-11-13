//
//  EditViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 11/12/15.
//  Copyright © 2015 NikHowlett. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import QuartzCore

class EditViewController: UIViewController {
    
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let managedContext : NSManagedObjectContext? = appDelegate.managedObjectContext {
            return managedContext
        } else {
            return nil
        }
    }()
    
    var classNameSent : String = ""
    
    var dateTimeSent : NSDate = NSDate()
    
    var classObjSent: NSManagedObject = NSManagedObject()
    
    var classes : [Class2] = [Class2]()

    @IBOutlet weak var classNameTextField: UITextField!
    
    @IBOutlet weak var pickerDateOutlet: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = "Edit Class"
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            managedObjectContext = appDelegate.managedObjectContext
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        if classNameSent != "" {
            classNameTextField.text = classNameSent
        }
        pickerDateOutlet.date = dateTimeSent
        /*self.navigationController? .setNavigationBarHidden(false, animated:true)
        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.addTarget(self, action: "methodCall:", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("Edit Class", forState: UIControlState.Normal)
        backButton.sizeToFit()
        let backButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backButtonItem*/
        // Do any additional setup after loading the view.
    }
    func methodCall(sender:UIBarButtonItem) {
        self.performSegueWithIdentifier("reloadProfPanel", sender: self)
    }
    @IBAction func methodjall(sender: AnyObject) {
        self.performSegueWithIdentifier("reloadProfPanel", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveEditedClass(sender: AnyObject) {
        let fetchRequest : NSFetchRequest = NSFetchRequest(entityName: "Class2")
        let error: NSError? = nil
        do { classes = try managedObjectContext?.executeFetchRequest(fetchRequest) as! [Class2] } catch _ as NSError { print("An error occurred loading the data") }
        if error != nil {
            print("An error occurred loading the data")
        }
        if classes.count > 0 {
            for (var i = 0; i < classes.count; i++) {
                if classes[i].courseName == classNameSent {
                    classes[i].courseName = classNameTextField.text!
                    classes[i].startTime = pickerDateOutlet.date
                }
            }
        }
        do{
            try managedObjectContext!.save()
        } catch let error as NSError{
            print(error)
            
        }
        let alert = UIAlertView()
        alert.title = "Saved"
        alert.message = "You have successfully edited the class."
        alert.addButtonWithTitle("Ok")
        alert.show()
    }

    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
