//
//  SecondViewController.swift
//  MeetUp3
//
//  Created by Zachary Eichenberger on 10/12/19.
//  Copyright © 2019 Zachary Eichenberger. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var myTableView: UITableView!
    
    var checkTime = 0000
    var friendsAvailable: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set checkTime
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        checkTime = 100*hour + minutes
        
        friendsAvailable = []
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsAvailable.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel!.text = friendsAvailable[indexPath.row]
        return cell
    }
    
    func minutes(time: Float) -> Int {
        let temp =  time.truncatingRemainder(dividingBy: 1) * 60
        let temp2 = Int(temp.rounded())
        if temp2 > 0 { return temp2
        } else { return 60 - temp2 }
    }
    func hours(time: Float) -> Int {
        return Int((time - 0.4999).rounded())
    }
    
    
    @IBAction func timeSliderChanged(_ sender: Any) {
        let t = timeSlider.value
        
        if t == 0 {
            timeLabel.text = "Friends Available Now"
        } else {
            timeLabel.text = String(format: "Friends Available in %2ih %2imin", hours(time: t), minutes(time: t))
        }
        
        let date = Date()
        let calendar = Calendar.current
        let hour = hours(time: t) + calendar.component(.hour, from: date)
        let minute = minutes(time: t) + calendar.component(.minute, from: date)

        checkTime = 100*hour + minute
    }
    
    @IBAction func timeSliderReleased(_ sender: Any) {
        // Update friendsAvailable
        myTableView.reloadData()
    }
    
    
}

