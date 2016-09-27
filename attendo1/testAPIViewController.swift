//
//  testAPIViewController.swift
//  attendo1
//
//  Created by Nik Howlett on 4/11/16.
//  Copyright © 2016 NikHowlett. All rights reserved.
//
//import SwiftHTTP
import UIKit
import Ji

enum JSONError: String, ErrorType {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}


class testAPIViewController: UIViewController {

    @IBOutlet weak var responseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func jsonParser() {
        //let urlPath = "gtwhereami.herokuapp.com/user/?start_datetime=1444521490&end_datetime=1444521560"
        let urlPath = "gtwhereami.herokuapp.com/user/device"
        guard let endpoint = NSURL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        let request = NSMutableURLRequest(URL:endpoint)
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                //responseLabel.text = data as String!
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                print(json)
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    }
    
    @IBAction func paf(sender: AnyObject) {
        jsonParser2()
    }
    
    func jsonParser2() {
        let superfirst = "gtwhereami.herokuapp.com/user/device"
        let url = NSURL(string: "\(superfirst)")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
            //print("Saved survey results!")
            self.responseLabel.text = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
        }
        task.resume()
        
        /*let url = "gtwhereami.herokuapp.com/user/device" as NSURL
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            
        }
        task.resume()*/
    }
    
    @IBAction func getData(sender: AnyObject) {
        jsonParser()
    }
    
    func jsonParser3() {
        let jiDoc = Ji(htmlURL: NSURL(string: "gtwhereami.herokuapp.com/user/")!)
        //let titleNode = jiDoc?.xPath("//head/title")?.first
        print(jiDoc)
    }
    @IBAction func jibut(sender: AnyObject) {
        jsonParser3()
    }
    
    func jsonParser4() {
        print("yes")
        /*do {
            let opt = try HTTP.New("gtwhereami.herokuapp.com/user/", method: .GET, requestSerializer: JSONParameterSerializer())
            opt.onFinish = { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                print("opt finished: \(response.description)")
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }*/
    }
    
    @IBAction func alamo(sender: AnyObject) {
        jsonParser4()
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
