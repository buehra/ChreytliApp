//
//  ViewController.swift
//  ChreytliV1
//
//  Created by Raphael Bühlmann on 24.01.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//

import UIKit
import Alamofire
import JSONJoy
import LocalAuthentication

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var headers = [String:String]()
    var pages : Int = 0
    
    var submissions = [Submit]()
    
    @IBOutlet weak var collectView: UICollectionView!
    
    @IBOutlet weak var login: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectView.delegate = self
        collectView.dataSource = self
        
        getSubmissions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return submissions.count

    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CustomCellView = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CustomCellView
        cell.TextAuthor.text = submissions[indexPath.row].author?.name
        cell.image.imageFromUrl(submissions[indexPath.row].imgUrl!)
        cell.textDienst.text = submissions[indexPath.row].dienst
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Cell \(indexPath.row) selected")
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let lastRowIndex = collectView.numberOfItemsInSection(0)
        if indexPath.row == lastRowIndex - 1 {
            pages++
            getSubmissions()
        }
    }
    

    func setHeader(tocken: Tocken){
        
        if tocken.tokentype == nil{
            let alertController = UIAlertController(title: "Fehler", message: "Login fehlgeschlagen!", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in}
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        
        }else{
        
            self.headers = [
                "Authorization": tocken.tokentype!+" "+tocken.accesstoken!,
                "Content-Type": "application/json"
            ]
            
            login.title = "Logout"
        }
    }
    
    
    func getSubmissions(){
    
        Alamofire.request(.GET, "http://api.chreyt.li/api/Submissions?page="+String(pages), headers: headers)
            .responseJSON { response in
                
                if response.result.isSuccess {
                    
                    let json = Submissions(JSONDecoder(response.result.value!))
                    
                    if json.submit?.count != 0{
                        
                        for name in json.submit! {
                            self.submissions.append(name)
                        }
                        
                        self.collectView.reloadData()

                    }
   
                }
        }
    }



    @IBAction func pressedLogin(sender: AnyObject) {
        
        switch login.title {
        case "Login"?:
            
            let alertController = UIAlertController(title: "Login", message: "Login", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in}
            alertController.addAction(cancelAction)
            
            let submitAction = UIAlertAction(title: "Login", style: .Default) { (action) in
                
                if let latitude = alertController.textFields![0].text, longitude = alertController.textFields![1].text{
                    let username : String = latitude
                    let password: String = longitude
                    
                    self.getTocken(username, password: password)
                    
                }
            }
            alertController.addAction(submitAction)
            
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Username"
                textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
            }
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Password"
                textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
            }
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        case "Logout"?:
            self.headers.removeAll()
            
            login.title = "Login"
            
            let alertController = UIAlertController(title: "Logout", message: "Erfolgreich ausgelogt!", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in}
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        default:
            self.headers.removeAll()
        }
    }
    
    func getTocken(username:String, password:String){
        
        let body = ["grant_type": "password", "userName": username, "password": password]
        
        Alamofire.request(.POST, "http://api.chreyt.li/Token", parameters: body)
            .responseJSON { response in
                
                if response.result.isSuccess {
                    let tocken = Tocken(JSONDecoder(response.result.value!))
                    self.setHeader(tocken)
                }
        }
    }
}

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
}
