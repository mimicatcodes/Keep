//
//  SetTimeForReminderVC.swift
//  Keep
//
//  Created by Luna An on 2/28/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

class SetTimeForReminderVC: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectedTimeLabel: UILabel!
    
    let formatter = DateFormatter()
    let store = DataStore.sharedInstance
    
    let userDefaults = UserDefaults.standard
    var selectedTime = Date()
    let calendar = Calendar.current
    
    var hour: Int?
    var minute: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let hr =  userDefaults.value(forKey: "hour") as? Int, let min = userDefaults.value(forKey: "minute") as? Int {
            if hr < 12 {
                let m = String(format: "%02d", min)
                selectedTimeLabel.text = "\(hr):\(m) AM"
            } else {
                let m = String(format: "%02d", min)
                let h = String(format: "%02d", (hr - 12))
                selectedTimeLabel.text = "\(h):\(m) PM"
            }
        }
        configureDatePicker()
        formatDate()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        hour = calendar.component(.hour, from: selectedTime)
        minute = calendar.component(.minute, from: selectedTime)
        
        if let hour = hour, let minute = minute {
            userDefaults.set(hour, forKey:"hour")
            userDefaults.set(minute, forKey: "minute")
            print("newly set hour is \(hour) and minute is \(minute)")
        }
        if let hour = UserDefaults.standard.value(forKey: "hour") as? Int, let minute = UserDefaults.standard.value(forKey: "minute") as? Int {
            Helper.setUpNotification(hour: hour, minute: minute)
            print("success?")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func configureDatePicker(){
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 1
        datePicker.layer.borderWidth = 1.0
        datePicker.layer.borderColor = Colors.tealish.cgColor
        datePicker.layer.cornerRadius = 8.0
        datePicker.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
    }
    
    func formatDate(){
        formatter.dateFormat =  "hh:mm a"
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        selectedTime = sender.date
        selectedTimeLabel.text = formatter.string(from: sender.date)
    }
}
