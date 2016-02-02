//
//  SubmitViewController.swift
//  ChreytliV1
//
//  Created by Raphael Bühlmann on 31.01.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//

import UIKit

class SubmitViewController: UIViewController{
    
    @IBOutlet weak var webBrowser: UIWebView!
    var URL : String = ""
    var type : Int = 0
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let teas = [ NSFontAttributeName: UIFont(name: "FontAwesome", size: 20)!]
        
        backBtn.setTitleTextAttributes(teas, forState: UIControlState.Normal)
        backBtn.title = "\u{f053}"
        
        loadBrowser()
        
    }
    
    func loadBrowser(){
    
        switch type {
        case 5:
            let htmlString:String! = URL
            webBrowser.loadHTMLString(htmlString, baseURL: nil)
        default:
            let url = NSURL (string: URL);
            let requestObj = NSURLRequest(URL: url!);
            webBrowser.loadRequest(requestObj);
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func returnGesture(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func goBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
}

