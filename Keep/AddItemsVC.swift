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
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityMinusButton: UIButton!
    @IBOutlet weak var purchaseDateTextfield: UITextField!
    @IBOutlet weak var expDateTextfield: UITextField!
    @IBOutlet weak var categoryTextfield: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        saveButton.isEnabled = false
        saveButton.backgroundColor = UIColor.clear
        quantity = 1
        quantityLabel.text = "\(quantity)"
        formatInitialDate()

    }
    
    @IBAction func purchaseDateDidBeginEditing(_ sender: UITextField) {
        
        formatDate()
        
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if nameTextfield.text != nil && nameTextfield.text != "" {
            
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor.cyan
            
        }
        
        return true
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
    
    
    func formatDate() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
        purchaseDateTextfield.text = formatter.string(from: datePicker.date).uppercased()
        
    }
    
    func formatInitialDate() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
        purchaseDateTextfield.text = formatter.string(from: NSDate() as Date).uppercased()
        let currentDate = NSDate()
        datePicker.setDate(currentDate as Date, animated: false)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        purchaseDateTextfield.inputView = datePicker
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        purchaseDateTextfield.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
        
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
        purchaseDateTextfield.text = formatter.string(from: sender.date).uppercased()
        
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

