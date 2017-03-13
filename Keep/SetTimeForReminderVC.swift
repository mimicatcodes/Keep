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
        if let hr =  userDefaults.value(forKey: Keys.UserDefaults.hour) as? Int, let min = userDefaults.value(forKey: Keys.UserDefaults.minute) as? Int {
            
            let format = DateFormat.doubleDigitTime
            if hr < 12 && hr > 0 {
                let m = String(format: format, min)
                selectedTimeLabel.text = "\(hr):\(m) AM"
            } else if hr == 12 {
                let m = String(format: format, min)
                selectedTimeLabel.text = "\(12):\(m) PM"
            } else if hr == 0 {
                let m = String(format: format, min)
                selectedTimeLabel.text = "\(12):\(m) AM"
            }else {
                let m = String(format: format, min)
                let h = String(format: format, (hr - 12))
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
            userDefaults.set(hour, forKey:Keys.UserDefaults.hour)
            userDefaults.set(minute, forKey: Keys.UserDefaults.minute)
        }
        if let hour = UserDefaults.standard.value(forKey: Keys.UserDefaults.hour) as? Int, let minute = UserDefaults.standard.value(forKey: Keys.UserDefaults.minute) as? Int {
            Helper.setUpNotification(hour: hour, minute: minute)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func configureDatePicker(){
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 10
        datePicker.layer.borderWidth = 1.0
        datePicker.layer.borderColor = Colors.tealish.cgColor
        datePicker.layer.cornerRadius = 8.0
        datePicker.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
    }
    
    func formatDate(){
        formatter.dateFormat =  DateFormat.time
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        selectedTime = sender.date
        selectedTimeLabel.text = formatter.string(from: sender.date)
    }
}
