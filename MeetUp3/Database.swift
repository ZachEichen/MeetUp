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
    //var lastRead: String = "";
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

    func makeFriends(nameThatIcantRemember : String) -> Bool { // make friends cause i'm lonley


      let friendNames :[String] = FriendDict.allKeys()
      var foundName : String;
      for str in friendNames{
        if str == nameThatICantRemember {
           foundName = str
        }
      }
      // if no matching names are found return false
      if foundName.isEmpty { return false; }
      else {
        // read array to find max index
        let currLen = FriendDict[foundName]["friend_requested_by"].count
        // write new Array to value
        ref.child("people").child(foundName).child("friend_requested_by").setValue([currLen : username])
      }
      return true;
    }

    //accepting friends
    // retrns true if success false otherwise
    //Assume friend is a valid friend.
    func acceptFriend(name:String) -> Bool {
      // add name to both friend lists

      // add to your list
      let currLen = FriendDict[username]["friends"].count
      // write new Array to value
      ref.child("people").child(friend).child(friend).setValue([currLen : username])

      // add to their list
       currLen = FriendDict[name]["friends"].count
      // write new Array to value
      ref.child("people").child(name).child(friend).setValue([currLen : username])

      // find instance of name
      let targ = FriendDict[name]["friends"].allKeysForObject(name)[0];
      // remove name from pending list
      ref.child("people").child(username).child("friend_requested_by").child(targ).removeValue()

      return true;
    }


    func checkVals() {
        print(self.friends)
        print(self.friendRequests)
        print(self.sleepStart)
        print(self.sleepEnd)
    }

}
