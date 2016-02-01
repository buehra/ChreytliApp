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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textURL.text = "\u{f16a} Facebook"
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }

}
