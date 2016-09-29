//
//  ViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 11/7/15.
//  Copyright (c) 2015 NikHowlett. All rights reserved.
//

import UIKit
import UIKit
import CoreData
import QuartzCore
//AVCaptureMetadataOutputObjectsDelegate
var TSAuthenticatedReader2: TSReader!
let TSLogoutNotification2 = "edu.gatech.cal.logout"
let TSDismissWebViewNotification2 = "edu.gatech.cal.dismissWeb"

class ViewController: UIViewController {
    
    @IBOutlet weak var usernametextfield: UITextField!
    
    @IBOutlet weak var passwordtextfield: UITextField!
    var classes1: [Class]?
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("console output: true")
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newCasLogin(newLogin newLogin: Bool) {
        print("function called")
        //print(TSAuthenticatedReader2.getAllClasses())
        //attempt to authenticate
        dispatch_async(TSNetworkQueue, {
            TSReader.authenticatedReader(user: self.usernametextfield.text!, password: self.passwordtextfield.text!, isNewLogin: newLogin, completion: { reader in
                print("dispatch_async called")
                //successful login
                if let reader = reader {
                    //let loginCount = 29//
                    print("this shit worked")
                    
                        //NSUserDefaults.standardUserDefaults().integerForKey(TSLoginCountKey)
                    /*NSUserDefaults.standardUserDefaults().setInteger(loginCount + 1, forKey: TSLoginCountKey)*/
                    
                    TSAuthenticatedReader2 = reader
                    self.presentClassesView(reader)
                    //self.performSegueWithIdentifier("newStudent", sender: self)
                    /*self.animateFormSubviewsWithDuration(0.5, hidden: false)
                    self.animateActivityIndicator(on: false)
                    self.setSavedCredentials(correct: true)
                    self.presentClassesView(reader)*/
                }
                    
                else {
                    print("didn't work")
                    self.passwordtextfield.text = ""
                    /*shakeView(self.formView)*/
                    /*self.animateFormSubviewsWithDuration(0.5, hidden: false)
                    self.animateActivityIndicator(on: false)
                    self.setSavedCredentials(correct: false)*/
                }
                
            })
        })
    }

    @IBAction func Login(sender: AnyObject) {
        print("login button pressed")
        newCasLogin(newLogin: true)
        //old code for demos, prototypes and such
        /*
        if usernametextfield.text == "abowd" {
             self.performSegueWithIdentifier("teacherLogin", sender: self)
        } else if usernametextfield.text == "sampleTeacher" {
            self.performSegueWithIdentifier("newTeacher", sender: self)
        } else if usernametextfield.text == "teacher" {
            self.performSegueWithIdentifier("teacher", sender: self)
        } else if usernametextfield.text == "student" {
            self.performSegueWithIdentifier("newStudent", sender: self)
        } else if usernametextfield.text == "testAPI" {
            self.performSegueWithIdentifier("testAPI", sender: self)
        } else {
            self.performSegueWithIdentifier("studentLogin", sender: self)
        }*/
        /*if TeacherStudent.on {
            self.performSegueWithIdentifier("teacherLogin", sender: self)
        } else {
            self.performSegueWithIdentifier("studentLogin", sender: self)
        }*/
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //pragma mark - Unwind Seques
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        print("Called goToSideMenu: unwind action")
    }
    
    

    func presentClassesView(reader: TSReader) {
        //tapRecognizer.enabled = false
        var classes: [Class] = []
        var loadAttempt = 0
        while classes.count == 0 && loadAttempt < 4 && !reader.actuallyHasNoClasses {
            loadAttempt += 1
            classes = reader.getActiveClasses()
            print(classes)
            print("presentClassesView")
            classes1 = classes
            //self.prepareForS)
            if classes.count == 0 {
                reader.checkIfHasNoClasses()
            }
            
            if loadAttempt > 2 {
                HttpClient.clearCookies()
            }
        }
        
        if loadAttempt >= 4 {
            //present an alert and then exit the app if the classes aren't loading
            //this means a failed authentication looked like it passed
            //AKA I have no idea what happened
            let message = "This happens every now and then. Please restart Attend-O and try again. If this keeps happening, please send an email to nhowlett6@gatech.edu"
            let alert = UIAlertController(title: "There was a problem logging you in.", message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Restart", style: .Default, handler: { _ in
                //crash
                let null: Int! = nil
                //null.threeCharacterString()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            //self.setSavedCredentials(correct: false)
            return
        }
        //self.performSegueWithIdentifier("newStudent", sender: self)
        NSOperationQueue.mainQueue().addOperationWithBlock {
            [weak self] in
            self?.performSegueWithIdentifier("newStudent", sender: self)
        }
        
        //newStudentViewController.classes2 = classes
        //newStudentViewController.reloadTable()
         
         //open to the shortcut item if there is one queued
         /*if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
         delegate.openShortcutItemIfPresent()
         }*/
         
         //animatePresentClassesView()
         /*classesViewController.loadAnnouncements(reloadClasses: false, withInlineActivityIndicator: true)*/
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newStudent" {
            //if let classes = segue.destinationViewController as? newStudentViewController {
                //classes.classes2 = classes1
            //}
            let navVC = segue.destinationViewController as! UINavigationController
            
            let tableVC = navVC.viewControllers.first as! newStudentViewController
            
            tableVC.classes2 = classes1
            tableVC.username = usernametextfield.text!
        }
        
            /*print(TSAuthenticatedReader2.getActiveClasses())
             print("classesprinted")
             classes1 = classes.classes2*/
            //classes.loginController = self
            //classesViewController = classes
        
        /*if let browser = segue.destinationViewController as? TSWebView {
         browser.loginController = self
         self.browserViewController = browser
         }*/
    }

}

