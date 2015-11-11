//
//  SelectClassViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 11/10/15.
//  Copyright © 2015 NikHowlett. All rights reserved.
//

import UIKit

class SelectClassViewController: UIViewController {

    @IBOutlet weak var qrImage: UIImageView!
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if counter == 0 {
            qrImage.image = UIImage(named:"368px-QR_Code_Example.svg.png")
        } else if counter == 1 {
            qrImage.image = UIImage(named:"C6Eq0.png")
        } else if counter == 2 {
            qrImage.image = UIImage(named:"8396746.png")
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
    
    @IBAction func emwil(sender: AnyObject) {
    }
    
    @IBAction func newQR(sender: AnyObject) {
        counter = counter + 1
        if counter > 2 {
            counter = 0
        }
        if counter == 0 {
            qrImage.image = UIImage(named:"368px-QR_Code_Example.svg.png")
        } else if counter == 1 {
            qrImage.image = UIImage(named:"C6Eq0.png")
        } else if counter == 2 {
            qrImage.image = UIImage(named:"8396746.png")
        }
    }

}
