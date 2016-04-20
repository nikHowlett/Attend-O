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

class ViewController: UIViewController {

    @IBOutlet weak var LoginButton: UIButton!
    
    @IBOutlet weak var TeacherStudent: UISwitch!
    
    @IBOutlet weak var usernametextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Login(sender: AnyObject) {
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
        }
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

