//
//  Database.swift
//  MeetUp3
//
//  Created by Zachary Eichenberger on 10/12/19.
//  Copyright © 2019 Zachary Eichenberger. All rights reserved.
//
import Foundation
import FirebaseDatabase

class myDatabase{
    
    var ref: DatabaseReference!
    var lastRead: String = "";
    var IdDict : NSDictionary! ;
    var FriendDict : NSDictionary! ;
    
    var username: String = ""
    var meTime: Bool = false
    var sleepStart = 2300
    var sleepEnd = 0900
    var friendRequests: [String] = []
    var friends: [String] = []
    
    init () {
        ref = Database.database().reference();
        print(ref.description())
    }
    func fetchAndPrint(completion: (() -> Void)?){
        ref?.child("device_id").observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot);
            self.IdDict = snapshot.value as? NSDictionary ;
            //print("\(self.IdDict as AnyObject)");
        }, withCancel: { (error) in
           print(error.localizedDescription) })
        
        ref?.child("people").observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot);
            self.FriendDict = snapshot.value as? NSDictionary ;
            //print("\(self.FriendDict as AnyObject)");
            
            // Populate ME data from firebase
            let device_id = UIDevice.current.identifierForVendor?.uuidString
            if self.IdDict[device_id] != nil {
                self.username = self.IdDict[device_id] as! String

                let myDict = self.FriendDict[self.username] as! NSDictionary
                if myDict["me_time"] as! Int == 1 {
                    self.meTime = false
                } else {
                    self.meTime = false
                }
                self.sleepStart = myDict["sleep_start"] as! Int
                self.sleepEnd = myDict["sleep_end"] as! Int
                self.friendRequests = myDict["friend_requested_by"] as! [String]
                self.friends = myDict["friends"] as! [String]
                completion?()
                
                print(self.friends)
                print(self.friendRequests)
            }

        }, withCancel: { (error) in
           print(error.localizedDescription) })
        
        // Update username, metime, sleep hours
        //*/
    }
    
    func checkVals() {
        print(self.friends)
        print(self.friendRequests)
        print(self.sleepStart)
        print(self.sleepEnd)
    }
    
}
