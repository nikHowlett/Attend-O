//
//  NewTeechViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 4/8/16.
//  Copyright © 2016 NikHowlett. All rights reserved.
//

import UIKit

class NewTeechViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var classTable: UITableView!
    
    var items: [String] = ["CS 1331", "LMC 3400", "MATH 2407"]
    var days: [String] = ["MWF", "W", "TR"]
    var groups: [String] = ["A1", "F3", "B2"]
    
    var theClass = "CS 1331"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.classTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ClassCell")
        self.title = "Select a Class"
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
        cell.detailTextLabel?.text = self.days[indexPath.row]
        
        return cell
    }
        //return UITableViewCell()
    //}
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        theClass = items[indexPath.row]
        self.performSegueWithIdentifier("segueTest", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueTest") {
            let svc = segue.destinationViewController as! secondViewController;
            
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
