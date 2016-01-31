//
//  Models.swift
//  ChreytliV1
//
//  Created by Raphael Bühlmann on 24.01.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//

import Foundation
import JSONJoy

struct Event : JSONJoy{
    
    var Date:NSDate?
    var Title:String?
    var Descriptions:String?
    var AllDay:Bool?
    var Start:NSDate?
    var End:NSDate?
    
    
    init() {
        
    }
    init(_ decoder: JSONDecoder) {
        Title = decoder["title"].string
        Descriptions = decoder["description"].string
        let start = decoder["start"].string
        let end = decoder["end"].string
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        
        Start = dateFormatter.dateFromString(start!)
        End = dateFormatter.dateFromString(end!)
    }
    
}


struct Events : JSONJoy {
    var events: Array<Event>?
    init() {
    }
    init(_ decoder: JSONDecoder) {
        //we check if the array is valid then alloc our array and loop through it, creating the new address objects.
        if let addrs = decoder.array {
            events = Array<Event>()
            for addrDecoder in addrs {
                events?.append(Event(addrDecoder))
            }
        }
    }
}

struct Author : JSONJoy{
    
    var name : String?
    
    init() {
        
    }
    init(_ decoder: JSONDecoder) {
        name = decoder["userName"].string

    }
    
}

struct Submit : JSONJoy{
    
    var author: Author?
    
    var imgUrl : String?
    var Url : String?
    var score : Int?
    var type : Int?
    var dienst : String?
    
    init() {
        
    }
    init(_ decoder: JSONDecoder) {
        imgUrl = decoder["img"].string
        Url = decoder["url"].string
        score = decoder["score"].integer
        type = decoder["type"].integer
        switch type {
        case 0?:
            dienst = "Image"
            imgUrl = "http://api.chreyt.li/"+imgUrl!
            Url = "http://api.chreyt.li/"+Url!
        case 1?:
            dienst = "YouTube"
        case 2?:
            dienst = "Spotify"
        case 3?:
            dienst = "Video"
            imgUrl = "http://api.chreyt.li/"+imgUrl!
            Url = "http://api.chreyt.li/"+Url!
        case 4?:
            dienst = "Reddit"
        case 5?:
            dienst = "SoundCloud"
        default:
            dienst = "UnKnown"
        }
        author = Author(decoder["author"])
    
    }
    
}



struct Submissions : JSONJoy {
    var submit: Array<Submit>?
    init() {
    }
    init(_ decoder: JSONDecoder) {
        //we check if the array is valid then alloc our array and loop through it, creating the new address objects.
        if let authors = decoder.array {
            submit = Array<Submit>()
            for authDecoder in authors {
                submit?.append(Submit(authDecoder))
            }
        }
    }
}


struct Tocken : JSONJoy{
    
    var username : String?
    var tokentype : String?
    var accesstoken : String?
    
    
    init() {
        
    }
    init(_ decoder: JSONDecoder) {
        username = decoder["userName"].string
        tokentype = decoder["token_type"].string
        accesstoken = decoder["access_token"].string
    }
    
}