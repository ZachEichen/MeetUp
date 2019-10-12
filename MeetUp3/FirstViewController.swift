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
    
    let myFriends = ["Nicky Eichen", "Zachary Eichen", "Joey Wong"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        friendRequestTable.delegate = self
        friendRequestTable.dataSource = self
        myFriendsTable.delegate = self
        myFriendsTable.dataSource = self
        
        data.fetchAndPrint()
        
    }

    @IBAction func inviteButtonPressed(_ sender: Any) {
        let userID = UIDevice.current.identifierForVendor!.uuidString
        print(userID)
    }
    
    @IBAction func InviteButtonPressed(_ sender: Any) {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        print(deviceID)
    }
    // Tables:

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == myFriendsTable) {
            return myFriends.count
        } else if (tableView == friendRequestTable) {
            return 2
        } else {
            print("Uh Oh. How did anther table get in?")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == myFriendsTable) {
            print("configuring pending requests")
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell2", for: indexPath)
            cell.textLabel!.text = myFriends[indexPath.row]
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell2", for: indexPath)
            cell.textLabel!.text = myFriends[indexPath.row]
            return cell
            
        }
    }

}

