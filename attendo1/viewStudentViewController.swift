//
//  viewStudentViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 4/8/16.
//  Copyright © 2016 NikHowlett. All rights reserved.
//

import UIKit

class viewStudentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var classLabel: UILabel!
    
    @IBOutlet weak var studentTable: UITableView!
    
    @IBOutlet weak var buttOut: UIBarButtonItem!
    
    var toPass = "CS 1330"
    
    var tdate = "CS 1330"
    
    var checked = [Bool]()
    
    var students: [String] = ["John Hopkins", "Little Knight", "Donovan Rouge", "Sally Patch", "Hunter Robinson", "Drake Knightly"]
    
    var toolBarBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //76checked.
        for (var i = 0; i < students.count ; i++) {
            //checked[i] = false
            checked.append(false)
        }
        self.studentTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "StudentCell")
        dateLabel.text = tdate
        classLabel.text = toPass
        self.title = "Attendance"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
    
    @IBAction func pressToolButton(sender: AnyObject) {
        if toolBarBool {
            //add alert, Are you sure you want to edit this data?
            //studentTable.setEditing(true, animated: true)
            buttOut.title = "Edit Attendance Data"
            //buttOut.set
            toolBarBool = false
        } else {
            //alert: your changes have been updated
            studentTable.setEditing(false, animated: true)
            buttOut.title = "Done Editing"
            toolBarBool = true
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.studentTable.dequeueReusableCellWithIdentifier("StudentCell")! as UITableViewCell
        
        cell.textLabel?.text = self.students[indexPath.row]
        //cell.detailTextLabel?.text = self.students[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = studentTable.cellForRowAtIndexPath(indexPath) {
            if toolBarBool {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                checked[indexPath.row] = false
            } else {
                cell.accessoryType = .Checkmark
                checked[indexPath.row] = true
            }
            }
        }
    }
//enable editing
    //alert = are you sure you want to modify this data
    
//done editing
    //alert = your changes have been updated
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
