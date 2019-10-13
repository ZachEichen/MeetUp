//
//  SecondViewController.swift
//  MeetUp3
//
//  Created by Zachary Eichenberger on 10/12/19.
//  Copyright © 2019 Zachary Eichenberger. All rights reserved.
//

import UIKit
import Charts
import MessageUI

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myBarChart: BarChartView!
    
    var hour = 00
    var minute = 00
    var friendsAvailable: [String] = ["test 1", "test 2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        timeLabel.text = "Friends Available Now"
        friendsAvailable = data.friendsAvailableAtTime(deltaHours: hour, deltaMinutes: minute)
        
        setChartValues()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsAvailable.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel!.text = friendsAvailable[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let phoneNumber = (data.PeopleDict[friendsAvailable[indexPath.row]] as! NSDictionary)["phone"] as! Int
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Hey! You want to hang out?"
            controller.recipients = [String(phoneNumber)]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
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
        hour = hours(time: t)
        minute = minutes(time: t)
        friendsAvailable = data.friendsAvailableAtTime(deltaHours: hour, deltaMinutes: minute)
        print(friendsAvailable)
        myTableView.reloadData()
    }
    
    
    @IBAction func timeSliderReleased(_ sender: Any) {
        // Update friendsAvailable
        myTableView.reloadData()
    }
    
    func setChartValues(_ count : Int = 24) {
        var values: [ChartDataEntry] = []
        
        for i in 0...12 {
            let friends = data.friendsAvailableAtTime(deltaHours: i, deltaMinutes: 0)
            values.append(BarChartDataEntry(x: Double(i), y: Double(friends.count)))
        }
        //let x_axis_lable = ["Now", "2", "4", "6", "8", "10", "12", "14", "16", "18", "20", "22", "24"]
        let dataSet = BarChartDataSet(entries: values, label: "Friends")
        dataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]

        
        let chartData = BarChartData(dataSet: dataSet)
        
        self.myBarChart.data = chartData
        myBarChart.xAxis.labelPosition = .top
        myBarChart.backgroundColor = UIColor.clear
        myBarChart.xAxis.gridLineWidth = 0
        myBarChart.drawValueAboveBarEnabled = false
        myBarChart.drawGridBackgroundEnabled = false
        myBarChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        myBarChart.legend.enabled = false
    }

}

