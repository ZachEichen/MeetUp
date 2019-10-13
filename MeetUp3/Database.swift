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
    var PeopleDict : NSDictionary! ;

    var username: String = ""
    var meTime: Bool = false
    var sleepStart = 2300
    var sleepEnd = 0900
    var friendRequests: [String] = []
    var friends: [String] = []
    var myFriends : [Friend] = [];

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
            self.PeopleDict = snapshot.value as? NSDictionary ;
            //print("\(self.PeopleDict as AnyObject)");

            // Populate ME data from firebase
            let device_id = UIDevice.current.identifierForVendor?.uuidString
            if self.IdDict[device_id] != nil {
                self.username = self.IdDict[device_id] as! String

                let myDict = self.PeopleDict[self.username] as! NSDictionary
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

    func friendRequest(newFriend : String) -> String { // make friends cause i'm lonley

        // Check they exist and aren't already friends, and you haven't invited them yet
        let friendNames = PeopleDict.allKeys as! [String]
        if !friendNames.contains(newFriend) { return "User \(newFriend) Does Not Exist"; }
        
        let myfriends = PeopleDict[username] as! NSDictionary
        let myfriendsList = myfriends["friends"] as! [String]
        if myfriendsList.contains(newFriend) { return "You Are Already Friends"; }
        
        
        // read array to find max index
        let friendsdict = PeopleDict[newFriend] as! NSDictionary
        let req_friends_ls = friendsdict["friend_requested_by"] as! NSArray
        if req_friends_ls.contains(username) {return "You Have Already Friend-Requested"}
        
        let currlen = req_friends_ls.count
        // write new Array to value
        ref.child("people").child(newFriend).child("friend_requested_by").child(String(currlen)).setValue(username)
        return "successful";
    }

    //accepting friends
    // retrns true if success false otherwise
    //Assume friend is a valid friend.
    func acceptFriend(name:String) -> Bool {
        // add name to both friend lists

        // add to your list
        let currLen = ((PeopleDict[username] as! NSDictionary)["friends"] as!NSArray).count
        // write new Array to value
        ref.child("people").child(username).child("friends").child(String(currLen)).setValue(name)

        // add to their list
        let currLenFriend = ((PeopleDict[name] as! NSDictionary)["friends"] as!NSArray).count
        // write new Array to value
        ref.child("people").child(name).child("friends").child(String(currLenFriend)).setValue(username)

        // remove name from pending list
        var ind = -1
        let requested_ls = (PeopleDict[username] as! NSDictionary)["friend_requested_by"] as! NSArray
        var i = 1;
        while i < requested_ls.count {
            if (requested_ls[i] as! String  == name ){
                ind = i;
                break;
            }
            i = i+1;
        }
        
        
        ref.child("people").child(username).child("friend_requested_by").child(String(ind)).removeValue()

        return true;
    }
    
    func friendsAvailableAtTime(time: Int) -> [String] {
        var ppl: [String] = []
        for (key, dict) in PeopleDict {
            
        }
    }
    
    func populateFriends() ->Void{
        for name in  friends {
            let timeFree = PeopleDict ["free_hours"] as! NSDictionary
            let meTime = PeopleDict["me_time"] as! Bool
            myFriends.append(Friend(Name: name, TimeFree: timeFree, meTime: meTime))
        }
    }


    func checkVals() {
        print(self.friends)
        print(self.friendRequests)
        print(self.sleepStart)
        print(self.sleepEnd)
    }

}
