//
//  Friend.swift
//  MeetUp3
//
//  Created by Zachary Eichenberger on 10/12/19.
//  Copyright © 2019 Zachary Eichenberger. All rights reserved.
//

import Foundation

class Friend{
    let name : String
    let timeFree : NSDictionary
    let meTime : Bool;

    init(Name: String, TimeFree: NSDictionary, meTime :Bool){
        self.name = Name;
        self.timeFree = TimeFree
        self.meTime = meTime;
    }

    func getName() -> String {
        return name;
    }

    func isFreeAt(date: String, time : Int) -> Bool{
        if(meTime){ return false; }
        
        let timesArr = timeFree[date] as? NSDictionary
        // if the date is not listed, the person is not free
        if(timesArr == nil) {return true;}
        // if the date is listed, check if the time is in a "free range"
        for (str, arr) in timesArr as! NSDictionary {
            // parse start and end times for the free times
            let parts = (str as! String).split(separator: "-")
            let start = Int(parts[0]);
            let end =   Int(parts[1])
            print (parts);
            print (start);
            print (end);
            // check if the time checked is in the range given
            if(start! <= time && end! >= time) {
                return false;
            }
        }
      // if no correct values have been seen, return false;
        return true;
    }
}
