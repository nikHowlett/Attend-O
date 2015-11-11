//
//  YouveAttendedViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 11/10/15.
//  Copyright © 2015 NikHowlett. All rights reserved.
//

import UIKit

class YouveAttendedViewController: UIViewController {
    
    var classNameString : String = ""

    @IBOutlet weak var classNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if classNameString != "" {
            classNameLabel.text = classNameString
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
