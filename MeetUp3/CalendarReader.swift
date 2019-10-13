//
//  CalendarReader.swift
//  MeetUp3
//
//  Created by Zachary Eichenberger on 10/13/19.
//  Copyright © 2019 Zachary Eichenberger. All rights reserved.
//

import Foundation
import EventKit

class CalendarReader{
    var eventStore = EKEventStore()
    var calendar : Calendar;

    
    init() {
        // Get the appropriate calendar.
         calendar = Calendar.current

    }
    
    func getEventsAtDate(daysFromNow : Int) ->[String] {
        print("Told to get events")
        // Create the start date components
        var oneDayAgoComponents = DateComponents()
        oneDayAgoComponents.day = daysFromNow
        var oneDayAgo = calendar.date(byAdding: oneDayAgoComponents, to: Date() )

        // Create the end date components.
        var oneYearFromNowComponents = DateComponents()
        oneYearFromNowComponents.day = 1 + daysFromNow
        var oneYearFromNow = calendar.date(byAdding: oneYearFromNowComponents, to: Date())

        // Create the predicate from the event store's instance method.
        var predicate: NSPredicate? = nil
        if let anAgo = oneDayAgo, let aNow = oneYearFromNow {
            predicate = eventStore.predicateForEvents(withStart: anAgo, end: aNow, calendars: nil)
        }

        // Fetch all events that match the predicate.
        var events: [EKEvent]? = nil
        if let aPredicate = predicate {
            events = eventStore.events(matching: aPredicate)
        }
        
        var returnArray : [String] = []
        for event in events as! [EKEvent] {
            let fromTime = event.startDate as! Date
            let toTime = event.endDate as! Date
            
            let hourFrom = calendar.component(.hour, from: fromTime)
            let minuteFrom = calendar.component(.minute, from: fromTime)
            let hourTo = calendar.component(.hour, from: toTime)
            let minuteTo = calendar.component(.hour, from: toTime)

            let string = String(hourFrom*100 + minuteFrom) + "-" + String(hourTo*100 + minuteTo)
            returnArray.append(string)
        }
        return returnArray
    }    
}
