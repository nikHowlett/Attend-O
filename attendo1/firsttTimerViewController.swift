//
//  firsttTimerViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 11/2/16.
//  Copyright © 2016 NikHowlett. All rights reserved.
//

import UIKit
import SwiftyJSON

class firsttTimerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    var classes2: [Class]?
    var bitchoni: UIPickerView?
    var sections2: [String]?
    var username: String = "George P. Burdell"
    var items: [String] = ["CS 1332", "CS 2340", "CS 3750"]
    var sectionPerClass: [String] = []
    var coursePromtStringArray: [String]?
    let vw = UIView()
    var changeIndex = 0
    var changeSection = "A"
    @IBOutlet weak var theView: UIView!
    
    @IBAction func cellButton(sender: AnyObject) {
        print("ButtonCalled, printing index/row")
        var button : UIButton = sender as! UIButton
        //var row : Int = button.tag
        
        //print(row)
        print("//Load UI PICKER with sections that we get back from mitch coursesat api")
    }
    @IBOutlet weak var welcomeString: UILabel!
    @IBOutlet weak var classTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //theView.set
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        classTable.delegate = self
        classTable.dataSource = self
        classTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "sectionCell")
        //self.classTable.registerClass(SectionSelectionTableViewCell.self, forCellReuseIdentifier: "SectionCell")
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
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "sectionCell")
        
        cell.textLabel?.text = self.items[indexPath.row]
        cell.detailTextLabel?.text = self.sections2![indexPath.row]
        cell.detailTextLabel?.textColor = UIColor.blueColor()
        
        return cell
        //let cell:SectionSelectionTableViewCell = self.classTable.dequeueReusableCellWithIdentifier("SectionCell")! as! SectionSelectionTableViewCell
        
        //var cell = self.classTable.dequeueReusableCellWithIdentifier("SectionCell")! as! SectionSelectionTableViewCell
        //var cell = classTable.dequeueReusableCellWithIdentifier("SectionCell")
        /*var cell = classTable.dequeueReusableCellWithIdentifier("SectionCell")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "SectionCell")
        }
        /*let cellIdentifier = "SectionCell"
        var cell = classTable.dequeueReusableCellWithIdentifier("SectionCell", forIndexPath: indexPath)
        //var cell = classTable.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: cellIdentifier)
        }*/
        /*if cell == nil {
            //tableView.registerNib(UINib(nibName: "UICustomTableViewCell", bundle: nil), forCellReuseIdentifier: "UICustomTableViewCell")
            tableView.registerClass(SectionSelectionTableViewCell.classForCoder(), forCellReuseIdentifier: "SectionCell")
            cell = SectionSelectionTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "SectionCell")
            
        }*/
                cell!.detailTextLabel?.text? = self.sections2![indexPath.row]
        cell!.textLabel?.text = self.items[indexPath.row]
        
        /*cell.classLabel?.text = self.items[indexPath.row]
        cell.sectionButton?.setTitle(self.sections2![indexPath.row], forState: .Normal)
        cell.sectionButton?.setTitle(self.sections2![indexPath.row], forState: .Application)
        cell.sectionButton?.setTitle(self.sections2![indexPath.row], forState: .Selected)
        if #available(iOS 9.0, *) {
            cell.sectionButton?.setTitle(self.sections2![indexPath.row], forState: .Focused)
        } else {
            // Fallback on earlier versions
        }*/
        //cell.sectionButton.tag = indexPath.row

        return cell!// as UITableViewCell*/
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(items[indexPath.row])
        print(sections2![indexPath.row])
        changeIndex = indexPath.row
        //var rhow = indexPath as NSInteger
        var bitchfuck = coursePromtStringArray![indexPath.row].stringByReplacingOccurrencesOfString(" ", withString: "-")
        var parameters = ["courses":["\(bitchfuck)"]]
        print(parameters)
        let request = NSMutableURLRequest(URL: NSURL(string:"http://52.41.202.206/api/courseprompt")!)
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
                /*if let swifteejason = try JSON(data!) {
                 print("JSON: \(swifteejason)")
                 }*/
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print("Response: \(json)")
                    let swiftee = JSON(data: data!)
                    print("JSON: \(swiftee)")
                    print("JSON[courses] : \(swiftee["courses"])")
                    print("JSON: \(swiftee)")
                    print("JSON[courses][0][section] : \(swiftee["courses"][0]["section"])")
                    if let userName = swiftee[0]["userExists"].string {
                        let userbool = swiftee[0]["userExists"].bool
                        //print("userExists: \(userName)")
                        print("equal to false bool")
                        let homie = (userName == "False")
                        print("equal to false string \(homie)")
                        let john = (userbool == false)
                        
                    }
                    if let courseBithces = swiftee["courses"].array {
                        print("courseBithces")
                        self.sectionPerClass = []
                        print(courseBithces)
                        for (var k = 0; k < courseBithces.count; k++) {
                            print(courseBithces[k]["section"])
                            self.sectionPerClass.append("\(courseBithces[k]["section"])")
                        }
                        
                        
                    }
                    if (self.sectionPerClass.count > 0) {
                        self.showPickerInActionSheet()
                    }
                    /*if let courseBithces = swiftee["courses"].arrayValue as? JSON {
                        print(courseBithces)
                        for (var k = 0; k < courseBithces.count; k++) {
                            print(courseBithces[k]["section"])
                        }
                    }
                    if let courseBithces = swiftee["courses"].arrayObject {
                        print(courseBithces)
                        for (var k = 0; k < courseBithces.count; k++) {
                            print(courseBithces[k]["section"])
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
        //showPickerInActionSheet()
        //view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        /*vw.frame = CGRectMake(150, 150, 0, 0)
        vw.backgroundColor = UIColor.redColor()
        self.view.addSubview(vw)
        
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            
            self.vw.frame = CGRectMake(75, 75, 300, 300)
            
            }, completion: nil)
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)*/
        
        //self.performSegueWithIdentifier("segueTest", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "segueTest") {
            //let svc = segue.destinationViewController as! studentCalViewController;
            
            //svc.toPass = theClass
            
        }
    }
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        vw.removeFromSuperview()
        /*view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.backgroundColor = UIColor.d*/

    }
    @IBAction func test(sender: AnyObject) {
        //showPickerInActionSheet()
        for (var cC = 0; cC < classes2!.count; cC++) {
            //get Sections
            /*var parameters = ["courses":["\(bitchfuck)"]]
            print(parameters)
            let request = NSMutableURLRequest(URL: NSURL(string:"http://52.41.202.206/api/courseprompt")!)
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
                        print("JSON[courses] : \(swiftee["courses"])")
                    }
                }
            }*/
        }
    }
    func showPickerInActionSheet() {
        var title = "Choose Section"
        var message = "\n\n\n\n\n\n\n\n\n\n";
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet);
        alert.modalInPopover = true
        
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        var pickerFrame: CGRect = CGRectMake(17, 52, 270, 100); // CGRectMake(left), top, width, height) - left and top are like margins
        var picker: UIPickerView = UIPickerView(frame: pickerFrame);

        /* If there will be 2 or 3 pickers on this view, I am going to use the tag as a way
         to identify them in the delegate and datasource. /* This part with the tags is not required.
         I am doing it this way, because I have a variable, witch knows where the Alert has been invoked    from.*/
        if(sentBy == "profile"){
            picker.tag = 1;
        } else if (sentBy == "user"){
            picker.tag = 2;
        } else {
            picker.tag = 0;
        }*/
 
        //set the pickers datasource and delegate
        picker.delegate = self;
        picker.dataSource = self;
 
        //Add the picker to the alert controller
        alert.view.addSubview(picker);
        bitchoni = picker
 
        //Create the toolbar view - the view witch will hold our 2 buttons
        var toolFrame = CGRectMake(17, 5, 270, 45);
        var toolView: UIView = UIView(frame: toolFrame);
 
        //add buttons to the view
        var buttonCancelFrame: CGRect = CGRectMake(0, 7, 100, 30); //size & position of the button as placed on the toolView
 
        //Create the cancel button & set its title
        var buttonCancel: UIButton = UIButton(frame: buttonCancelFrame);
        buttonCancel.setTitle("Cancel", forState: UIControlState.Normal);
        buttonCancel.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal);
        toolView.addSubview(buttonCancel); //add it to the toolView
 
        //Add the target - target, function to call, the event witch will trigger the function call
        buttonCancel.addTarget(self, action: "cancelSelection:", forControlEvents: UIControlEvents.TouchDown);
 
 
        //add buttons to the view
        var buttonOkFrame: CGRect = CGRectMake(170, 7, 100, 30); //size & position of the button as placed on the toolView
 
        //Create the Select button & set the title
        var buttonOk: UIButton = UIButton(frame: buttonOkFrame);
        buttonOk.setTitle("Select", forState: UIControlState.Normal);
        buttonOk.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal);
        buttonOk
            .addTarget(self, action: "saveSection:", forControlEvents: UIControlEvents.TouchDown)
        toolView.addSubview(buttonOk) //add to the subview
 
        //Add the tartget. In my case I dynamicly set the target of the select button
        //if(sentBy == "profile"){
            //buttonOk.addTarget(self, action: "saveSection:", forControlEvents: UIControlEvents.TouchDown);
        //} else if (sentBy == "user"){
          //  buttonOk.addTarget(self, action: "saveUser:", forControlEvents: UIControlEvents.TouchDown);
        //}
 
        //add the toolbar to the alert controller
        alert.view.addSubview(toolView);
 
        self.presentViewController(alert, animated: true, completion: nil);
    }
    func saveSection(sender: UIButton) {
        //changeSection = bitchoni.
        sections2![changeIndex] = changeSection
        //cell.detailTextLabel?.text = self.sections2![indexPath.row]
        self.classTable.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func cancelSelection(sender: UIButton){
        print("Cancel");
        self.dismissViewControllerAnimated(true, completion: nil);
        // We dismiss the alert. Here we can add additional code to execute when cancel is pressed
    }
    func numberOfComponentsInPickerView(_pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        /*if(pickerView.tag == 1){
            return self.profilesList.count;
        } else if(pickerView.tag == 2){
            return self.usersList.count;
        } else  {
            return 0;
        }*/
        return sectionPerClass.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        //if sectionPerClass[row]. {
        //    var selectedSection: String = self.profilesList[row] as Profiles;
            //return selectedProfile.profileName;
            return sectionPerClass[row]
        //} else  {
            
          //  return "";
            
        //}
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            //var choosenProfile: Profiles = profilesList[row] as Profiles
            //self.selectedProfile = choosenProfile.profileName
        changeSection = sectionPerClass[row]
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
