//
//  FirstViewController.swift
//  MeetUp3
//
//  Created by Zachary Eichenberger on 10/12/19.
//  Copyright © 2019 Zachary Eichenberger. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var friendRequestTable: UITableView!
    @IBOutlet weak var myFriendsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data.fetchAndPrint(completion: {
            self.friendRequestTable.reloadData()
            self.myFriendsTable.reloadData()
        })
        friendRequestTable.delegate = self
        friendRequestTable.dataSource = self
        myFriendsTable.delegate = self
        myFriendsTable.dataSource = self
        
        print("begining wait")
        print("ending wait")
        data.checkVals()
        }

    @IBAction func inviteButtonPressed(_ sender: Any) {
        let userID = UIDevice.current.identifierForVendor!.uuidString
        print(userID)
        data.checkVals()
    }
    
    @IBAction func InviteButtonPressed(_ sender: Any) {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        print(deviceID)
    }
    // Tables:

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == myFriendsTable) {
            return data.friends.count
        } else if (tableView == friendRequestTable) {
            return data.friendRequests.count
        } else {
            print("Uh Oh. How did anther table get in?")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == myFriendsTable) {
            print("configuring pending requests")
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell2", for: indexPath)
            cell.textLabel!.text = data.friends[indexPath.row]
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell2", for: indexPath)
            cell.textLabel!.text = data.friendRequests[indexPath.row]
            return cell
            
        }
    }

}

