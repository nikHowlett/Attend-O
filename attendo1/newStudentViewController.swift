//
//  newStudentViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 4/10/16.
//  Copyright © 2016 NikHowlett. All rights reserved.
//

import UIKit

class newStudentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var items: [String] = ["CS 1332", "CS 2340", "CS 3750"]
    var groups: [String] = ["A1", "F3", "B2"]
    
    var theClass = "CS 1332"
    var classes2: [Class]?
    var username: String = "George P. Burdell"
    
    @IBOutlet weak var classTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.classTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ClassCell")
        self.title = "Select a Class"
        print(classes2)
        print("classes printed")
        if classes2?.count > 0 {
            var be = 0
            items = []
            while be < classes2?.count {
                items.append("\(classes2![be])")
                be = be + 1
            }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
