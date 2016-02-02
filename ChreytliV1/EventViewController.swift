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
    
    struct Objects {
        var sectionName : String!
        var sectionObjects: [Event]!
    }
    
    var objectsArray = [Objects]()

    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        let eventInStart = [Event]()
        
        
        objectsArray = [Objects(sectionName: "Januar", sectionObjects: eventInStart),
            Objects(sectionName: "Februar", sectionObjects: eventInStart),
            Objects(sectionName: "März", sectionObjects: eventInStart),
            Objects(sectionName: "April", sectionObjects: eventInStart),
            Objects(sectionName: "Mai", sectionObjects: eventInStart),
            Objects(sectionName: "Juni", sectionObjects: eventInStart),
            Objects(sectionName: "Juli", sectionObjects: eventInStart),
            Objects(sectionName: "August", sectionObjects: eventInStart),
            Objects(sectionName: "September", sectionObjects: eventInStart),
            Objects(sectionName: "Oktober", sectionObjects: eventInStart),
            Objects(sectionName: "November", sectionObjects: eventInStart),
            Objects(sectionName: "Dezember", sectionObjects: eventInStart)]
        
        getEvents()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return objectsArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsArray[section].sectionObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell

        cell.textLabel?.text = objectsArray[indexPath.section].sectionObjects[indexPath.row].Title
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsArray[section].sectionName
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let DateInFormat = dateFormatter.stringFromDate(objectsArray[indexPath.section].sectionObjects[indexPath.row].Start!)
        let DateInFormat2 = dateFormatter.stringFromDate(objectsArray[indexPath.section].sectionObjects[indexPath.row].End!)
        
        let message = "Start "+DateInFormat+" bis\n"+DateInFormat2
        
        let alertController = UIAlertController(title: objectsArray[indexPath.section].sectionObjects[indexPath.row].Title, message: message, preferredStyle: .Alert)
        
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
                self.createEvent(eventStore, title: self.objectsArray[indexPath.section].sectionObjects[indexPath.row].Title!, startDate: self.objectsArray[indexPath.section].sectionObjects[indexPath.row].Start!, endDate: self.objectsArray[indexPath.section].sectionObjects[indexPath.row].End!)
                
                let alertController = UIAlertController(title: "Erfolgreich", message: "Event wurde gespeichert!", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in}
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            })
        } else {
            self.createEvent(eventStore, title: self.objectsArray[indexPath.section].sectionObjects[indexPath.row].Title!, startDate: self.objectsArray[indexPath.section].sectionObjects[indexPath.row].Start!, endDate: self.objectsArray[indexPath.section].sectionObjects[indexPath.row].End!)
            
            let alertController = UIAlertController(title: "Erfolgreich", message: "Event wurde gespeichert!", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in}
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    
    }
    
    
    func getEvents(){
        SwiftLoading().showLoading()
        
        Alamofire.request(.GET, "http://api.chreyt.li/api/events")
            .responseJSON { response in
                
                if response.result.isSuccess {
                    let json = Events(JSONDecoder(response.result.value!))
                    
                    for name in json.events!{
                        
                        self.events.append(name)
    
                    }
                    self.groupEvents()
                    
                    
                    self.tableView.reloadData()
                    SwiftLoading().hideLoading()
                }
        }
    }
    
    func groupEvents(){
        
        
        self.events.sortInPlace({ $0.Start!.compare($1.Start!) == NSComparisonResult.OrderedAscending })
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM"
        
        let dateFormatterYear = NSDateFormatter()
        dateFormatterYear.dateFormat = "YYYY"
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        
        for event in self.events{
            
            let index = Int(dateFormatter.stringFromDate(event.Start!))! - 1
            
            
            if Int(dateFormatterYear.stringFromDate(event.Start!)) == year{
                
                objectsArray[index].sectionObjects.append(event)
            
            }
            
            
        }
        
        self.events.removeAll()
        
    
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
