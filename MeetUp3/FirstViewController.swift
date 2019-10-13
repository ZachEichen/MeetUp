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
    @IBOutlet weak var friendInvite: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        friendRequestTable.delegate = self
        friendRequestTable.dataSource = self
        myFriendsTable.delegate = self
        myFriendsTable.dataSource = self
        }

    func fetchData() {
        data.fetchAndPrint(completion: {
            self.friendRequestTable.reloadData()
            self.myFriendsTable.reloadData()
        })
    }
    
    @IBAction func inviteButtonPressed(_ sender: Any) {
        let userID = UIDevice.current.identifierForVendor!.uuidString
        print(userID)
        data.checkVals()
    }
    
    @IBAction func InviteButtonPressed(_ sender: Any) {
        if friendInvite.text == "" {
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
            let friendAffermed = data.friendRequests[indexPath.row + 1]
            data.acceptFriend(name: friendAffermed)
            fetchData()
        }
    }


}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

