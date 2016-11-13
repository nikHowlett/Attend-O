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
import SwiftyJSON
//AVCaptureMetadataOutputObjectsDelegate
var TSAuthenticatedReader2: TSReader!
let TSLogoutNotification2 = "edu.gatech.cal.logout"
let TSDismissWebViewNotification2 = "edu.gatech.cal.dismissWeb"

class ViewController: UIViewController {
    
    @IBOutlet weak var usernametextfield: UITextField!
    
    @IBOutlet weak var passwordtextfield: UITextField!
    var classes1: [Class]?
    var sections1: [String]?
    var Jigalo: [String]?
    var bitchtwoni: [String] = []
    required init(coder aDecoder: NSCoder) {
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
                    print("password incorrect")
                    /*shakeView(self.formView)*/
                    /*self.animateFormSubviewsWithDuration(0.5, hidden: false)
                     self.animateActivityIndicator(on: false)
                     self.setSavedCredentials(correct: false)*/
                }
                
            })
        })
    }
    @IBAction func testMyCourses(sender: AnyObject) {
        var parameters = ["Username":"Admin", "Password":"123","DeviceId":"87878"] as Dictionary<String, String>
        parameters = ["username":"\(usernametextfield.text!)"]
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.41.202.206/api/mycourses")!)
        
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        //Note : Add the corresponding "Content-Type" and "Accept" header. In this example I had used the application/json.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print("Response: \(json)")
                } else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
        }
        
        task.resume()
    }
    
    @IBAction func printTest(sender: AnyObject) {
        /*var classes: [Class] = []
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
         }*/
    }
    
    @IBAction func Login(sender: AnyObject) {
        print("login button pressed")
        var parameters = ["Username":"Admin", "Password":"123","DeviceId":"87878"] as Dictionary<String, String>
        parameters = ["username":"\(usernametextfield.text!)"]
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.41.202.206/api/mycourses")!)
        
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        //Note : Add the corresponding "Content-Type" and "Accept" header. In this example I had used the application/json.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                //alert, having problmes connecting to Attend-O server
                return
            }
            
            do {
                /*if let swifteejason = try JSON(data!) {
                 print("JSON: \(swifteejason)")
                 }*/
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print("Response: \(json)")
                    let swiftee = JSON(data: data!)
                    print("JSON: \(swiftee)")
                    print("JSON[userExists] : \(swiftee["userExists"])")
                    if swiftee["userExists"] {
                        self.performSegueWithIdentifier("newStudent", sender: self)
                    } else {
                        self.newCasLogin(newLogin: true)
                    }
                    /*if let userName = swiftee[0]["userExists"].string {
                        let userbool = swiftee[0]["userExists"].bool
                        //print("userExists: \(userName)")
                        print("equal to false bool")
                        let homie = (userName == "False")
                        print("equal to false string \(homie)")
                        let john = (userbool == false)
                        if john {
                            self.newCasLogin(newLogin: true)
                        } else {
                            self.performSegueWithIdentifier("newStudent", sender: self)
                        }
                    }*/
                    
                    //if userexits is false, then go to userSetup
                    //if true, pull classes from database
                    
                } else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
        }
        
        task.resume()
        
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
        var sections: [String] = []
        var loadAttempt = 0
        while classes.count == 0 && loadAttempt < 4 && !reader.actuallyHasNoClasses {
            loadAttempt += 1
            classes = reader.getActiveClasses()
            sections = reader.getActiveSections()
            
            print("below classes")
            print(classes)
            print("below origSections")
            print(sections)
            print("presentClassesView")
            classes1 = classes
            sections1 = sections
            var barbie = false
            var barbieindex = 0
            var barbiearray: [Int] = []
            //barbie = need to increasesection count becasue of a non-class thing on tsquare
            for (var k = 0; k < classes.count; k += 1) {
                
                var spliterator = ("\(classes[k])").componentsSeparatedByString(" ")
                if spliterator[0].containsString("/") {
                    spliterator = spliterator[0].componentsSeparatedByString("/")
                }
                //add case for CS/PSYC 3790 split by / if contains /
                for (var j = 0; j < GTSubjectPrefixes.count; j += 1) {
                    if spliterator[0] == GTSubjectPrefixes[j] {
                        barbie = true
                        barbieindex = k + 1 - 1
                        barbiearray.append(barbieindex)
                        //barbiearray.arrayByAddingObject(barbieindex)
                        print("printing barbie index")
                        print(barbieindex)
                    }
                }
            }
            var kl2 = 0
            for (var kl = 0; kl < classes.count; kl += 1) {
                if kl != barbiearray[kl2] {
                    kl2 = kl2 - 1
                    sections.insert("", atIndex: kl)
                }
                kl2++
            }
            /*if sections.count > classes.count {
             var banana = sections.indexOf("")
             sections.removeAtIndex(banana!)
             }*/
            print("printing sections14")
            print(sections)
            sections1 = sections
            /*if barbie {
             var sections14: [String] = []
             for (var jk = 0; jk < sections.count; jk += 1) {
             if (barbieindex == jk) {
             sections14.append("")
             }
             sections14.append(sections[jk])
             }
             print("printing sections14")
             print(sections14)
             sections1 = sections14
             //sections.insert("", atIndex: barbieindex)
             }*/
            print("below new sections")
            print(sections1!)
            var coursePromter = reader.getCoursePromt(sections1!)
            Jigalo = coursePromter
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
            self?.performSegueWithIdentifier("firstTimer", sender: self)
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
    
    func wahooni() {
        var parameters = ["username":"\(usernametextfield.text!)"]
        print(parameters)
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.41.202.206/api/mycourses")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                //alert, having problmes connecting to Attend-O server
                return
            }
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print("Response: \(json)")
                    let swiftee = JSON(data: data!)
                    print("JSON: \(swiftee)")
                    print("JSON[userExists] : \(swiftee["userExists"])")
                    print("JSON: \(swiftee)")
                    if let msgF = swiftee["userExists"].bool {
                        if msgF == true {
                            if let courseArray = swiftee["courses"].array {
                                var beachie: [String] = []
                                for (var k = 0; k < courseArray.count; k++) {
                                    beachie.append(courseArray[k]["course"].string!)
                                }
                                if beachie.count > 0 {
                                    self.bitchtwoni = beachie
                                }
                                print("below supposed to be class strings")
                                print(self.bitchtwoni)
                            }
                            
                            
                        }
                    }
                    
                    /*{
                     "err": false,
                     "msg": "Created User"
                     }*/
                    //"setupComplete"
                    
                } else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
        }
        //let fjfj = segue.destinationViewController.
        
        task.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newStudent" {
            wahooni()
            let navVC = segue.destinationViewController as! UINavigationController
            
            let tableVC = navVC.viewControllers.first as! newStudentViewController
            
            //tableVC.classes2 = classes1
            tableVC.username = self.usernametextfield.text!
            tableVC.classes2 = self.bitchtwoni
            //if let classes = segue.destinationViewController as? newStudentViewController {
            //classes.classes2 = classes1
            //}
            
            
            
        } else if segue.identifier == "firstTimer" {
            let navVC = segue.destinationViewController as! UINavigationController
            
            let tableVC = navVC.viewControllers.first as! firsttTimerViewController
            // newStudentViewController
            
            tableVC.classes2 = classes1
            tableVC.sections2 = sections1
            tableVC.username = usernametextfield.text!
            tableVC.coursePromtStringArray = Jigalo
            
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
    
    let GTSubjectPrefixes: [String] = [
        "ACCT",
        "AE",
        "AS",
        "APPH",
        "ASE",
        "ARBC",
        "ARCH",
        "BIOL",
        "BMEJ",
        "BMED",
        "BMEM",
        "BC",
        "CETL",
        "CHBE",
        "CHEM",
        "CHIN",
        "CP",
        "CEE",
        "COA",
        "COE",
        "CX",
        "CSE",
        "CS",
        "COOP",
        "UCGA",
        "EAS",
        "ECON",
        "ECEP",
        "ECE",
        "ENGL",
        "FS",
        "FREN",
        "GT",
        "GTL",
        "GRMN",
        "HS",
        "HIST",
        "HTS",
        "ISYE",
        "ID",
        "IPIN",
        "IPFS",
        "IPSA",
        "INTA",
        "IL",
        "INTN",
        "IMBA",
        "JAPN",
        "KOR",
        "LS",
        "LING",
        "LMC",
        "MGT",
        "MOT",
        "MSE",
        "MATH",
        "ME",
        "MP",
        "MSL",
        "MUSI",
        "NS",
        "NRE",
        "PERS",
        "PHIL",
        "PHYS",
        "POL",
        "PTFE",
        "DOPP",
        "PSYC",
        "PUBP",
        "PUBJ",
        "RUSS",
        "SOC",
        "SPAN"]
    
}
