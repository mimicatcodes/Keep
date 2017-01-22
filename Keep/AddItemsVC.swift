//
//  AddItemsVC.swift
//  Keep
//
//  Created by Luna An on 1/16/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class AddItemsVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    
    var store = DataStore.sharedInstance
    var location:Location = .Fridge
    var quantity: Int = 1
    var labelView: UILabel!
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    var activeTextField:UITextField?
    let formatter = DateFormatter()
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityMinusButton: UIButton!
    @IBOutlet weak var purchaseDateTextfield: UITextField!
    @IBOutlet weak var expDateTextfield: UITextField!
    @IBOutlet weak var categoryTextfield: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor.clear
        customToolBarForPickers()
        formatInitialDate()
        formatDates()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatInitialDate()
        formatDates()
    }
    
    func formatDates(){
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
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
        
        expDateTextfield.inputAccessoryView = toolBar
        purchaseDateTextfield.inputAccessoryView = toolBar
    }
    
    func donePicker(sender:UIBarButtonItem){
        
        activeTextField?.resignFirstResponder()
    
    }
    
    @IBAction func didPressExpDateBtn(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            let today = Date()
            let fiveDaysLater = Calendar.current.date(byAdding: .day, value: 5, to: today)
            if let date = fiveDaysLater {
                
                expDateTextfield.text = formatter.string(from: date).uppercased()
            }
        case 1:
            let today = Date()
            let aWeekLater = Calendar.current.date(byAdding: .day, value: 7, to: today)
            if let date = aWeekLater {
                expDateTextfield.text = formatter.string(from: date).uppercased()
            }
        case 2:
            let today = Date()
            let twoWeeksLater = Calendar.current.date(byAdding: .day, value: 14, to: today)
            if let date = twoWeeksLater {
                expDateTextfield.text = formatter.string(from: date).uppercased()
            }
        case 3:
            expDateTextfield.text = "None"
        default:
            break
            
        }
    }
    
    
    @IBAction func didPressLocationBtn(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            self.location = .Fridge
            print("-------Fridge btn tapped: location is \(location)")
        // Implement button animations here
        case 1:
            self.location = .Freezer
            print("-------Freezer btn tapped: location is \(location)")
        case 2:
            self.location = .Pantry
            print("-------Pantry btn tapped: location is \(location)")
        case 3:
            self.location = .Other
            print("-------Other btn tapped: location is \(location)")
        default:
            break
            
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        saveButton.isEnabled = false
        
        guard let name = nameTextfield.text, name != "" else { return }
        guard let purchaseDate = purchaseDateTextfield.text, purchaseDate != "" else { return }
        guard let expDate = expDateTextfield.text, expDate != "" else { return }
        guard let category = categoryTextfield.text, category != "" else { return }
        
        let item = Item(name: name, quantity: String(quantity), expDate: expDate, purchaseDate: purchaseDate, isConsumed: false, location: location.rawValue, category: category)
        
        let realm = try! Realm()
        try! realm.write {
            
            realm.add(item)
            print("***** \(item.name) is added to realm database in \(item.category) ***** ")
            
        }
        
        showAlert()
        resetAddItems()
    
    }
    
    @IBAction func quantityMinusBtnTapped(_ sender: Any) {
        
        // Disable the button if the label is 1
        if quantity == 1 {
            
            quantityMinusButton.isEnabled = false
            
        } else {
            
            quantityMinusButton.isEnabled = true
            quantity -= 1
            quantityLabel.text = "\(quantity)"
            
        }
        
    }
    
    @IBAction func quantityPlusBtnTapped(_ sender: Any) {
        
        quantity += 1
        quantityLabel.text = "\(quantity)"
        if quantityMinusButton.isEnabled == false {
            quantityMinusButton.isEnabled = true
            
        }
    }
    
    func showAlert() {
        
        labelView = UILabel(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: 50))
        labelView.backgroundColor = UIColor.darkGray
        labelView.text = "Item Added!"
        labelView.textAlignment = .center
        labelView.textColor = UIColor.white
        labelView.font = UIFont(name: "AvenirNextCondensed-Regular", size: 20)
        
        self.view.addSubview(labelView)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
        
    }
    
    func dismissAlert(){
        
        if labelView != nil {
            
            labelView.removeFromSuperview()
            
        }
    }
    
    func formatDateForTextFields() {
        
        purchaseDateTextfield.text = formatter.string(from: datePicker1.date).uppercased()
        expDateTextfield.text = formatter.string(from: datePicker2.date).uppercased()
        
    }
    
    func formatInitialDate() {
        
        quantity = 1
        quantityLabel.text = "\(quantity)"
        purchaseDateTextfield.text = formatter.string(from: Date()).uppercased()
        expDateTextfield.text = formatter.string(from: Date()).uppercased()
        let currentDate = Date()
        datePicker1.setDate(currentDate, animated: false)
        datePicker2.setDate(currentDate, animated: false)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if nameTextfield.text != nil && nameTextfield.text != "" {
            
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor.cyan
            
        }
        
        return true
    }
    

    
    func textFieldDidBeginEditing(_ textField: UITextField){
     
        activeTextField = textField

        purchaseDateTextfield.inputView = datePicker1
        datePicker1.datePickerMode = UIDatePickerMode.date
        datePicker1.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
        
        expDateTextfield.inputView = datePicker2
        datePicker2.datePickerMode = UIDatePickerMode.date
        datePicker2.addTarget(self, action: #selector(self.datePickerChanged(sender:)), for: .valueChanged)
        
        formatDateForTextFields()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
         activeTextField?.resignFirstResponder()

        return true
    }
    
    
    func datePickerChanged(sender: UIDatePicker) {
        
        if sender == datePicker1 {
            purchaseDateTextfield.text = formatter.string(from: sender.date).uppercased()
        } else if sender == datePicker2 {
            expDateTextfield.text = formatter.string(from: sender.date).uppercased()
        }
        
    }
    
    func resetAddItems(){
        
        nameTextfield.text = nil
        quantity = 1
        quantityLabel.text = "1"
        formatInitialDate()
        expDateTextfield.text = nil
        location = .Fridge
        categoryTextfield.text = nil
        nameTextfield.becomeFirstResponder()
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor.clear
        
    }
    
}

