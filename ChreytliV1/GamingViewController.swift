//
//  GamingViewController.swift
//  ChreytliV1
//
//  Created by Raphael Bühlmann on 29.01.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//

import UIKit

class GamingViewController: UIViewController{

    @IBOutlet weak var myBrowser: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localfilePath = NSBundle.mainBundle().URLForResource("home", withExtension: "html");
        let myRequest = NSURLRequest(URL: localfilePath!);
        myBrowser.loadRequest(myRequest);

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
