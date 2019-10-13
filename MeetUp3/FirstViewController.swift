//
//  FirstViewController.swift
//  MeetUp3
//
//  Created by Zachary Eichenberger on 10/12/19.
//  Copyright © 2019 Zachary Eichenberger. All rights reserved.
//

import UIKit
import EventKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var friendRequestTable: UITableView!
    @IBOutlet weak var myFriendsTable: UITableView!
    @IBOutlet weak var friendInvite: UITextField!
    
    var eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        friendRequestTable.delegate = self
        friendRequestTable.dataSource = self
        myFriendsTable.delegate = self
        myFriendsTable.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func fetchData() {
        data.fetchAndPrint(completion: {
            self.friendRequestTable.reloadData()
            self.myFriendsTable.reloadData()
            self.checkCalendarAuthorizationStatus()
        })
    }
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
            data.pushDictAtDate(daysFromNow: 0)
            data.pushDictAtDate(daysFromNow: 1)
            data.pushDictAtDate(daysFromNow: 2)
            data.pushDictAtDate(daysFromNow: 3)

        case EKAuthorizationStatus.authorized:
            // Get Those Datas
            data.pushDictAtDate(daysFromNow: 0)
            data.pushDictAtDate(daysFromNow: 1)
            data.pushDictAtDate(daysFromNow: 2)
            data.pushDictAtDate(daysFromNow: 3)
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            print("Error, needs calendar authorization")
        }
    }
    func requestAccessToCalendar() {
        EKEventStore().requestAccess(to: .event, completion: {
            (accessGranted: Bool, error: Error?) in
            if accessGranted == true {
                //get those datas
            }
        })
    }
    

    
    
    @IBAction func inviteButtonPressed(_ sender: Any) {
        let userID = UIDevice.current.identifierForVendor!.uuidString
        print(userID)
        data.checkVals()
    }
    
    @IBAction func InviteButtonPressed(_ sender: Any) {
        if friendInvite.text == "" || friendInvite.text == "_" {
            let deviceID = UIDevice.current.identifierForVendor?.uuidString
            print(deviceID)
            fetchData()
        } else {
            let result = data.friendRequest(newFriend: friendInvite.text!)
            
            if result != "successful" {
                let alertController = UIAlertController(title: "Error:", message: result, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "I will rethink my life choices :(", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        fetchData()
    }
    // Tables:

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == myFriendsTable) {
            return data.friends.count - 1
        } else if (tableView == friendRequestTable) {
            return data.friendRequests.count - 1
        } else {
            print("Uh Oh. How did anther table get in?")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == myFriendsTable) {
            print("configuring pending requests")
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell2", for: indexPath)
            cell.textLabel!.text = data.friends[indexPath.row + 1]
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell2", for: indexPath)
            cell.textLabel!.text = data.friendRequests[indexPath.row + 1]
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == friendRequestTable {
            print("friend request answer")
            let friendAffermed = data.friendRequests[indexPath.row + 1]
            
            // Create the alert controller
            let alertController = UIAlertController(title: "Friend Request", message: "User \(friendAffermed) would like to be friends with you!", preferredStyle: .alert)

            // Create the actions
            let okAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default) {
                UIAlertAction in
                data.acceptFriend(name: friendAffermed)
                self.fetchData()
            }
            let cancelAction = UIAlertAction(title: "Reject", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                data.rejectFriend(name: friendAffermed)
                self.fetchData()
            }

            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)

            // Present the controller
            self.present(alertController, animated: true, completion: nil)

            fetchData()
        }
    }
}
