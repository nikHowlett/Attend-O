//
//  SelectClassViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 11/10/15.
//  Copyright © 2015 NikHowlett. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import QuartzCore
import MessageUI

class SelectClassViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var qrImage: UIImageView!
    
    var classNameSent : String = ""
    
    var dateTimeSent : NSDate = NSDate()
    
    var classObjSent: Class2 = Class2()
    
    var counter = 0
    
    var filestring : String = ""
    
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
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBAction func newQR(sender: AnyObject) {
        counter = counter + 1
        if counter > 2 {
            counter = 0
        }
        if counter == 0 {
            qrImage.image = UIImage(named:"368px-QR_Code_Example.svg.png")
            filestring = "368px-QR_Code_Example.svg"
        } else if counter == 1 {
            qrImage.image = UIImage(named:"C6Eq0.png")
            filestring = "C6Eq0"
        } else if counter == 2 {
            qrImage.image = UIImage(named:"8396746.png")
            filestring = "8396746"
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    /*func getAttachmentPath() -> String{
        let attachmentFileName = filestring
        let attachmentPath = NSTemporaryDirectory().stringByAppendingPathComponent(attachmentFileName)
        return attachmentPath
    }*/
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        let resip = ["abowd"]
        mailComposerVC.setToRecipients(resip)
        mailComposerVC.setSubject("Attend-O Auto-Generated QR Code")
        let jenkins = "For Class \(classNameSent) at time \(dateTimeSent)"
        var body: String = "<html><body>For Class \(classNameSent) at time \(dateTimeSent) QR code below<br/>"
        /*if let imageData2 = UIImageJPEGRepresentation(qrImage.image!, 0.0) {
            let base64String2: String = imageData2.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
            body = body + "<div><img src='data:image/png;base64,\(base64String2)' height='100' width='150'/></div>"
        }
        if let imageData = UIImagePNGRepresentation(qrImage.image!)
            // Get the image from ImageView and convert to NSData
        {
            let base64String: String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
            body = body + "<div><img src='data:image/png;base64,\(base64String)' height='100' width='150'/></div>"
        }
        body = body + "</body></html>"
        mailComposerVC.setToRecipients(["attendo3750@gmail.com"])
        mailComposerVC.setMessageBody(body, isHTML: true)*/
        mailComposerVC.setMessageBody(body, isHTML: true)
        if let filePath = NSBundle.mainBundle().pathForResource(filestring, ofType: "png") {
            print("File path loaded.")
            
            if let fileData = NSData(contentsOfFile: filePath) {
                print("njjjjjjjjjjFile data loaded.")
                mailComposerVC.addAttachmentData(fileData, mimeType: "image/png", fileName: "QRCode")
            }
        }
        //mailComposerVC.setMessageBody("\(jenkins)", isHTML: false)
        return mailComposerVC
    }

}
