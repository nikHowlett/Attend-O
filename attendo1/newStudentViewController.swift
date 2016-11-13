//
//  newStudentViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 4/10/16.
//  Copyright © 2016 NikHowlett. All rights reserved.
//

import UIKit
import SwiftyJSON

class newStudentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBAction func fdf(sender: AnyObject) {
        classTable.reloadData()
        print("classes2")
        print(classes2)
        print("bitchtwoni")
        print(bitchtwoni)
        print("username")
        print(username)
        welcomeString.text! = "Welcome \(username)"
    }
    var items: [String] = ["CS 1332", "CS 2340", "CS 3750"]
    var groups: [String] = ["A1", "F3", "B2"]
    
    var theClass = "CS 1332"
    var classes2: [String] = []
    var bitchtwoni: [String] = []
    var username: String = "George P. Burdell"
    
    @IBOutlet weak var welcomeString: UILabel!
    
    @IBOutlet weak var classTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var oldView = parentViewController?.parentViewController as! ViewController
        //var oldNav = parentViewController as! UINavigationController
        //oldNav.p
        //var olDpoo = oldNav.parentViewController as! ViewController
        //classes2 = olDpoo.bitchtwoni
        //username = olDpoo.usernametextfield.text!
        self.wahooni()
        self.classes2 = self.bitchtwoni
        self.classTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ClassCell")
        self.title = "Select a Class"
        print(classes2)
        print("classes printed")
        if classes2.count > 0 {
            var be = 0
            items = []
            while be < classes2.count {
                items.append("\(classes2[be])")
                be = be + 1
            }
            welcomeString.text! = "Welcome \(username)"
        }
        //self.classes = TSAuthenticatedReader2.getActiveClasses()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.classTable.dequeueReusableCellWithIdentifier("ClassCell")! as UITableViewCell
        
        
        cell.textLabel?.text = self.items[indexPath.row]
        cell.detailTextLabel?.text = self.groups[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        theClass = items[indexPath.row]
        self.performSegueWithIdentifier("segueTest", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueTest") {
            let svc = segue.destinationViewController as! studentCalViewController;
            
            svc.toPass = theClass
            
        }
    }
    
    func wahooni() {
        var parameters = ["username":"\(username)"]
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
                                    self.classes2 = beachie
                                    self.bitchtwoni = beachie
                                    self.items = beachie
                                }
                                print("below supposed to be class strings")
                                //classes2 = bitchtwoni
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
