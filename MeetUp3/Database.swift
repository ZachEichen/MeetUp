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
    
    init () {
        ref = Database.database().reference();
        print(ref.description())
    }
    func fetchAndPrint(){
        ref?.child("device_id").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot);
            self.IdDict = snapshot.value as? NSDictionary ;
            print("\(self.IdDict as AnyObject)");
        }, withCancel: { (error) in
           print(error.localizedDescription) })
        
        ref?.child("people").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot);
            self.FriendDict = snapshot.value as? NSDictionary ;
            print("\(self.FriendDict as AnyObject)");
        }, withCancel: { (error) in
           print(error.localizedDescription) })
    }

    
}
