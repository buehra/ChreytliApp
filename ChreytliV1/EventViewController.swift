//
//  EventViewController.swift
//  ChreytliV1
//
//  Created by Raphael Bühlmann on 30.01.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//

import UIKit
import Alamofire
import JSONJoy
import EventKit

class EventViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var savedEventId : String = ""
    var events = [Event]()

    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        getEvents()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell

        cell.textLabel?.text = events[indexPath.row].Title
        
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let DateInFormat = dateFormatter.stringFromDate(events[indexPath.row].Start!)
        let DateInFormat2 = dateFormatter.stringFromDate(events[indexPath.row].End!)
        
        let message = "Start "+DateInFormat+" bis\n"+DateInFormat2
        
        let alertController = UIAlertController(title: events[indexPath.row].Title, message: message, preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Speichern", style: .Default) { (action) in
            
            self.saveEvent(indexPath)
        }
        alertController.addAction(saveAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in}
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    func saveEvent(indexPath: NSIndexPath){
        
        let eventStore = EKEventStore()
        
        if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                granted, error in
                self.createEvent(eventStore, title: self.events[indexPath.row].Title!, startDate: self.events[indexPath.row].Start!, endDate: self.events[indexPath.row].End!)
                
                let alertController = UIAlertController(title: "Erfolgreich", message: "Event wurde gespeichert!", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in}
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            })
        } else {
            self.createEvent(eventStore, title: self.events[indexPath.row].Title!, startDate: self.events[indexPath.row].Start!, endDate: self.events[indexPath.row].End!)
            
            let alertController = UIAlertController(title: "Erfolgreich", message: "Event wurde gespeichert!", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in}
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    
    }
    
    
    func getEvents(){
        
        Alamofire.request(.GET, "http://api.chreyt.li/api/events")
            .responseJSON { response in
                
                if response.result.isSuccess {
                    let json = Events(JSONDecoder(response.result.value!))
                    
                    for name in json.events!{
                        
                        self.events.append(name)
    
                    }
                    
                    self.tableView.reloadData()
                }
        }
    }
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
            savedEventId = event.eventIdentifier
        } catch {
            print("Bad things happened")
        }
    }

}
