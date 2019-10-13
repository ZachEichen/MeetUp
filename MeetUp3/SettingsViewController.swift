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
    @IBOutlet weak var phoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = data.username
        meTimeSwitch.isOn = data.meTime
        phoneNumber.text = String(data.phone)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HHmm"

        let date = dateFormatter.date(from: String(format: "%04d", data.sleepStart))
        fromTime.date = date!
        
        let date2 = dateFormatter.date(from: String(format: "%04d", data.sleepEnd))
        toTime.date = date2!

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    @IBAction func saveChangesPressed(_ sender: Any) {
        // Write new values to firebase
        data.writeUsername(n: usernameTextField.text as! String)
        data.writeMeTime(b: meTimeSwitch.isOn)
        data.writePhone(n: Int(phoneNumber.text as! String) ?? 0)
        
        let calendar = Calendar.current
        let hourFrom = calendar.component(.hour, from: fromTime.date)
        let minuteFrom = calendar.component(.minute, from: fromTime.date)
        let hourTo = calendar.component(.hour, from: toTime.date)
        let minuteTo = calendar.component(.hour, from: toTime.date)
        

        data.writeSleepFrom(n: hourFrom*100 + minuteFrom)
        data.writeSleepTo(n: hourTo*100 + minuteTo)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        
        
    }
}
