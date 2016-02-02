//
//  PostSubViewController.swift
//  ChreytliV1
//
//  Created by Raphael Bühlmann on 31.01.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//PostSubViewController

import UIKit

class PostSubViewController: UIViewController{
    
    @IBOutlet weak var textURL: UITextField!
    @IBOutlet weak var backBtn: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let teas = [ NSFontAttributeName: UIFont(name: "FontAwesome", size: 20)!]
        
        backBtn.setTitleTextAttributes(teas, forState: UIControlState.Normal)
        backBtn.title = "\u{f053}"
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
