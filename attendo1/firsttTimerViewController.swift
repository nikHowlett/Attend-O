//
//  firsttTimerViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 11/2/16.
//  Copyright © 2016 NikHowlett. All rights reserved.
//

import UIKit

class firsttTimerViewController: UIViewController {

    var classes2: [Class]?
    var sections2: [String]?
    var username: String = "George P. Burdell"
    var items: [String] = ["CS 1332", "CS 2340", "CS 3750"]
    
    @IBOutlet weak var welcomeString: UILabel!
    @IBOutlet weak var classTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.classTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SectionCell")
        self.title = "Confirm Section"
        if classes2?.count > 0 {
            var be = 0
            items = []
            while be < classes2?.count {
                items.append("\(classes2![be])")
                be = be + 1
            }
            welcomeString.text! = "Welcome \(username)"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classes2!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:SectionSelectionTableViewCell = self.classTable.dequeueReusableCellWithIdentifier("SectionCell")! as! SectionSelectionTableViewCell
        
        
        cell.textLabel?.text = self.items[indexPath.row]
        cell.detailTextLabel?.text = self.sections2![indexPath.row]
        
        return cell
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
