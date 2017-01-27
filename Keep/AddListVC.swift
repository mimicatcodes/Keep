//
//  AddListVC.swift
//  Keep
//
//  Created by Luna An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class AddListVC: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDelegate {
    
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    var activeTextField:UITextField?
    
    @IBOutlet weak var listTitle: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var createListView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        listTitle.delegate = self
        dateField.delegate = self
        customToolBarForPickers()
        formatInitialData()
        formatDates()
        hideKeyboard()
        setupViews()
    }
    
    func formatInitialData(){
        let currentDate = Date()
        dateField.text = formatter.string(from: currentDate).uppercased()
        datePicker.setDate(currentDate, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
        
        if textField == dateField {
            dateField.inputView = datePicker
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
            dateField.text = formatter.string(from: datePicker.date).uppercased()

        }
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        
       dateField.text = formatter.string(from: sender.date).uppercased()
    
    }

    func customToolBarForPickers(){
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        dateField.inputAccessoryView = toolBar
        listTitle.inputAccessoryView = toolBar
    
    }
    
    func formatDates(){
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
    }

  
    func donePicker(sender:UIBarButtonItem){
        
        activeTextField?.resignFirstResponder()
        
    }
    
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        print("Add button tapped")
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func setupViews(){
        view.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.35)
        createListView.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.00)
    }
    
    
}
