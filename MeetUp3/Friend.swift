//
//  Friend.swift
//  MeetUp3
//
//  Created by Zachary Eichenberger on 10/12/19.
//  Copyright © 2019 Zachary Eichenberger. All rights reserved.
//

import Foundation

class Friend{
    let private name : String
    let private timeFree : NSDictionary
    let meTime : Bool;

    init(Name: String, TimeFree: NSDictionary, meTime :Bool){
      self.name = name;
      self.timeFree = NSDictionary
      self.meTime = meTime;
    }

    func getName() --> String {
      return name;
    }

    func isFreeAt(date: String, time : Int) --> Bool{
      if(meTime){ return false; }
      let timesArr = timeFree["date"] as? String[] : nil
      // if the date is not listed, the person is not free
      if(timesArr == nil) {return false;}
      // if the date is listed, check if the time is in a "free range"
      for (str, arr) in timesArr {
        // parse start and end times for the free times
        let parts = str.componentsSeperatedByString("-")
        let start = (Int)parts[0];
        let end =   (Int)Parts[1]
        print (parts);
        print (start);
        print (end);
        // check if the time checked is in the range given
        if(start <= time && end >= time) {
          return true;
        }
      }
      // if no correct values have been seen, return false;
      return false;
    }
}
