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
                    
                    TSAuthenticatedReader = reader
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

}

