//
//  ViewController.swift
//  TLDR
//
//  Created by Laikh Tewari on 11/14/15.
//  Copyright © 2015 Laikh Tewari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textfield: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var conceptsLabel: UILabel! {
        didSet {
            self.activityIndicator.stopAnimating()
        }
    }
    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func analyzeTapped(sender: AnyObject) {
        self.view.endEditing(true)
        //self.activityIndicator.hidden = false
        //self.activityIndicator.startAnimating()
        //concepts request
        let conceptsRequest = NSMutableURLRequest(URL: NSURL(string: "https://api.havenondemand.com/1/api/sync/extractconcepts/v1")!)
        conceptsRequest.HTTPMethod = "POST"
        let conceptsPostString = "apikey=1740b746-e944-4a4b-bb8e-766ce433e976&text=\(textfield.text)"
        conceptsRequest.HTTPBody = conceptsPostString.dataUsingEncoding(NSUTF8StringEncoding)
        let conceptsTask = NSURLSession.sharedSession().dataTaskWithRequest(conceptsRequest) {
            data, response, error in
            
            do
            {
                let object:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if let dictionary = object as? NSDictionary
                {
                    if let array = dictionary["concepts"] as? NSArray
                    {
                        if let first = array[0] as? NSDictionary
                        {
                            if let concept = first["concept"]
                            {
                                self.conceptsLabel.text = "Concept: \((concept as? String)!)"
                            }
                        }
                    }
                }
                
                //print ("\(object)")
                //completeWith(object, response, nil)
            } catch let caught as NSError {
                // completeWith(nil, response, caught)
            } catch {
                // Something else happened.
                // Insert your domain, code, etc. when constructing the error.
                //let error: NSError = NSError(domain: "<Your domain>", code: 1, userInfo: nil)
                //completeWith(nil, nil, error)
            }

            //print("MY RESPONSE IS HERE\(response?.valueForKey("aggregate"))")
            
        }
        conceptsTask.resume()
        
        self.activityIndicator.startAnimating()
        //sentiment request
        activityIndicator.startAnimating()
        let sentimentRequest = NSMutableURLRequest(URL: NSURL(string: "https://api.havenondemand.com/1/api/sync/analyzesentiment/v1")!)
        sentimentRequest.HTTPMethod = "POST"
        let postString = "apikey=1740b746-e944-4a4b-bb8e-766ce433e976&text=\(textfield.text)"
        sentimentRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let sentimentTask = NSURLSession.sharedSession().dataTaskWithRequest(sentimentRequest) {
            data, response, error in
            
            //print("RESPONSE = \(response)")
            
            //let myDataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            let json = JSON(data: data!)
//            if let sentiment = json["aggregate"]["score"].string
//            {
//                self.view.endEditing(true)
//                self.sentimentLabel.text = sentiment
//            }
            do
            {
                let object:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                
                if let dictionary = object as? NSDictionary
                {
                    if let aggregate = dictionary["aggregate"]
                    {
                        if let sentiment = aggregate["sentiment"]
                        {
                            self.sentimentLabel.text = "Sentiment: \((sentiment as? String)!)"
                            if let value = aggregate["score"]
                            {
                                self.sentimentLabel.text! =  self.sentimentLabel.text! + " \(round((value! as! Double) * 100))%"
                                
                            }
                        }
                        
                    }
                }
                //completeWith(object, response, nil)
            } catch let caught as NSError {
               // completeWith(nil, response, caught)
            } catch {
                // Something else happened.
                // Insert your domain, code, etc. when constructing the error.
                //let error: NSError = NSError(domain: "<Your domain>", code: 1, userInfo: nil)
                //completeWith(nil, nil, error)
            }
            
            //print(myDataString)
        
        }
        sentimentTask.resume()
        
//        self.activityIndicator.startAnimating()
//        //language request
//        activityIndicator.startAnimating()
//        let languageRequest = NSMutableURLRequest(URL: NSURL(string: "https://api.havenondemand.com/1/api/sync/analyzesentiment/v1")!)
//        languageRequest.HTTPMethod = "POST"
//        let languagePostString = "apikey=1740b746-e944-4a4b-bb8e-766ce433e976&text=\(textfield.text)"
//        //print("LANGUAGE POST STRING: \(languagePostString)")
//        languageRequest.HTTPBody = languagePostString.dataUsingEncoding(NSUTF8StringEncoding)
//        let languageTask = NSURLSession.sharedSession().dataTaskWithRequest(languageRequest) {
//            data, response, error in
//            
//            //print("RESPONSE = \(response)")
//            
//            //let myDataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            //            let json = JSON(data: data!)
//            //            if let sentiment = json["aggregate"]["score"].string
//            //            {
//            //                self.view.endEditing(true)
//            //                self.sentimentLabel.text = sentiment
//            //            }
//            do
//            {
//                let object:AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
//                
//                if let dictionary = object as? NSDictionary
//                {
//                    if let language = dictionary["language"] 
//                    {
//                        self.languageLabel.text = "Language: \((language as? String)!)"
//                    }
//                }
//                
//               // print ("\(object)")
//                //completeWith(object, response, nil)
//            } catch let caught as NSError {
//                // completeWith(nil, response, caught)
//            } catch {
//                // Something else happened.
//                // Insert your domain, code, etc. when constructing the error.
//                //let error: NSError = NSError(domain: "<Your domain>", code: 1, userInfo: nil)
//                //completeWith(nil, nil, error)
//            }
//            
//            //print(myDataString)
//            
//        }
//        languageTask.resume()
    }
    
    
}

