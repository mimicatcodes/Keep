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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--------------\(userDefaults.object(forKey: "timeForReminder"))")
        selectedTime = userDefaults.object(forKey: "timeForReminder") as? Date ?? Date()
        print(selectedTime.localTime)
        selectedTimeLabel.text = formatter.string(from: selectedTime)
        configureDatePicker()
        formatDate()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        userDefaults.set(selectedTime, forKey:"timeForReminder")
        Helper.setLocalNotification(date: selectedTime)
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
        formatter.dateFormat =  "hh:mm a"
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        selectedTime = sender.date
        print(selectedTime)
        selectedTimeLabel.text = formatter.string(from: sender.date)
    }
}
