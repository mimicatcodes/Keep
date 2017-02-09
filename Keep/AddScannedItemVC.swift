//
//  AddScannedItemVC.swift
//  Keep
//
//  Created by Luna An on 2/8/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift

class AddScannedItemVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIBarPositioningDelegate, UINavigationControllerDelegate  {

    let store = DataStore.sharedInstance
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet var locationButtons: [UIButton]!
    @IBOutlet weak var expDateField: UITextField!
    @IBOutlet weak var pDateField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    var selectedIndex: Int = 0
    var selectedExpIndex: Int?
    var filteredItems = [Item]()
    let formatter = DateFormatter()
    var quantity = 1
    var expDate = Date()
    var purchaseDate = Date()
    var location: Location = .Fridge
    var activeTextField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        nameField.autocapitalizationType = .words
        expDateField.delegate = self
        pDateField.delegate = self
        categoryField.delegate = self
        categoryField.autocapitalizationType = .words
        formatInitialData()
        formatDates()
        customToolBarForPickers()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = store.scannedItemToAdd
        formatInitialData()
        formatDates()
    }
    
    @IBAction func favButtonTapped(_ sender: Any) {
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let name = nameField.text, name != "" else { return }
        guard let quantity = quantityLabel.text, quantity != "" else { return }
        //guard let expDate = expDateField.text, expDate != "" else { return }
        //guard let purchaseDate = pDateField.text, purchaseDate != "" else { return }
        guard let category = categoryField.text, category != "" else { return }
        
        let realm = try! Realm()
        try! realm.write {
          let item = Item(name: name, quantity: quantity, exp: expDate, purchaseDate: purchaseDate, isConsumed: false, location: location.rawValue, category: category)
            print("scanned item to add to realm is \(item)")
            realm.add(item)
        }
        
       NotificationCenter.default.post(name: REFRESH_SCANNED_ITEMS, object: nil)
        
    
        dismiss(animated: true, completion: nil)
    }
    
    
    func formatInitialData() {

        categoryField.text = ""
        quantity = 1
        quantityLabel.text = "\(quantity)"
        for (index,button) in locationButtons.enumerated() {
            if index == 0 {
                button.isSelected = true
                button.backgroundColor = .clear
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 2
                button.layer.borderColor = MAIN_COLOR.cgColor
                locationButtons[index].backgroundColor = MAIN_COLOR
                
            } else {
                button.isSelected = false
                button.backgroundColor = .clear
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.clear.cgColor
                locationButtons[index].backgroundColor = MAIN_BUTTON_LABEL_GRAY
            }
        }
        
        pDateField.text = formatter.string(from: Date()).capitalized
        let currentDate = Date()
        expDateField.text = formatter.string(from: Date()).capitalized
        datePicker1.setDate(currentDate, animated: false)
        datePicker2.setDate(currentDate, animated: false)
    }
    
    func formatDates(){
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
        
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        
        if sender == datePicker1 {
            purchaseDate = sender.date
            pDateField.text = formatter.string(from: sender.date).capitalized
        } else if sender == datePicker2 {
            expDate = sender.date
            expDateField.text = formatter.string(from: sender.date).capitalized
        }
        
    }
    
    func resetAddItems(){
        
        formatInitialData()
        saveButton.isEnabled = false
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        activeTextField?.resignFirstResponder()
        return true
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
        
        expDateField.inputAccessoryView = toolBar
        pDateField.inputAccessoryView = toolBar
        
    }


    func donePicker(sender:UIBarButtonItem) {
        
        activeTextField?.resignFirstResponder()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        activeTextField = textField
        print("???????????\(activeTextField)")
        
        if textField.tag == 0 {
            
            pDateField.inputView = datePicker1
            datePicker1.datePickerMode = .date
            datePicker1.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
            pDateField.text = formatter.string(from: datePicker1.date).capitalized
            
        } else if textField.tag == 1 {
            
            expDateField.inputView = datePicker2
            datePicker2.datePickerMode = UIDatePickerMode.date
            datePicker2.addTarget(self, action: #selector(self.datePickerChanged(sender:)), for: .valueChanged)
            expDateField.text = formatter.string(from: datePicker2.date).capitalized
        }
    }

}
