//
//  SettingsViewController.swift
//  MeetUp3
//
//  Created by Zachary Eichenberger on 10/12/19.
//  Copyright © 2019 Zachary Eichenberger. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var meTimeSwitch: UISwitch!
    @IBOutlet weak var fromTime: UIDatePicker!
    @IBOutlet weak var toTime: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = data.username
        meTimeSwitch.isOn = data.meTime
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HHmm"

        let date = dateFormatter.date(from: String(format: "%04d", data.sleepStart))
        fromTime.date = date!
        
        let date2 = dateFormatter.date(from: String(format: "%04d", data.sleepEnd))
        toTime.date = date2!


    }

    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        
        
    }
}
