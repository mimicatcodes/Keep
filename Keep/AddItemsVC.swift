//
//  AddItemsVC.swift
//  Keep
//
//  Created by Luna An on 1/16/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class AddItemsVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UIBarPositioningDelegate {
    
    var store = DataStore.sharedInstance
    var location:Location = .Fridge
    var quantity: Int = 1
    var labelView: UILabel!
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    var activeTextField:UITextField?
    let formatter = DateFormatter()
    var selectedIndex: Int = 0
    var selectedExpIndex: Int?
    var allItems = Array(DataStore.sharedInstance.allItems)
    var filteredItems = [Item]()
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityMinusButton: UIButton!
    @IBOutlet weak var purchaseDateTextfield: UITextField!
    @IBOutlet weak var expDateTextfield: UITextField!
    @IBOutlet var locationViews: [UIView]!
    @IBOutlet var locationButtons: [UIButton]!
    @IBOutlet var locationLabels: [UILabel]!
    @IBOutlet var expButtons: [UIButton]!

    @IBOutlet weak var categoryTextfield: UITextField!

    
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        saveButton.isEnabled = false
        customToolBarForPickers()
        quantityLabel.layer.borderWidth = 1
        quantityLabel.layer.borderColor = MAIN_COLOR.cgColor
        formatInitialData()
        nameTextField.setBottomBorder()
        formatDates()
        hideKeyboard()
        tableView.isHidden = true
        nameTextField.delegate = self
        categoryTextfield.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldActive), for: UIControlEvents.touchDown)
    
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    func textFieldActive() {
        tableView.isHidden = !tableView.isHidden
    }
    
    override func viewDidLayoutSubviews() {

        heightConstraint.constant = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatInitialData()
        formatDates()
        
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nameTextField {
            
            let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            searchAutocompleteEntriesWithSubstring(substring)
            
            return true

        }
            
            return true
        
        
    }
    

    func searchAutocompleteEntriesWithSubstring(_ substring: String) {
    
        filteredItems.removeAll(keepingCapacity: false)
        
        for item in allItems {
            
            let myString: NSString! = item.name as NSString
            let substringRange: NSRange! = myString.range(of: substring)
            
            if substringRange.location == 0 {
                filteredItems.append(item)
            }
        }
        
        tableView.reloadData()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredItems.count == 0 {
            
            return allItems.count
            
        }
      
        return filteredItems.count
    
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell")
        
        if filteredItems.count == 0 {
            
            cell?.textLabel?.text = self.allItems[indexPath.row].name
            
        } else {
            
            cell?.textLabel?.text = self.filteredItems[indexPath.row].name

        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        
        nameTextField.text = selectedCell.textLabel!.text!
        tableView.isHidden = true
        nameTextField.endEditing(true)
        tableView.reloadData()
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
        
        let index_ = sender.tag
        
        switch index_ {
            
        case 0:
            let today = Date()
            let fiveDaysLater = Calendar.current.date(byAdding: .day, value: 5, to: today)
            if let date = fiveDaysLater {
                
                expDateTextfield.text = formatter.string(from: date).uppercased()
            }
            
            print("5 Days")
            
        case 1:
            let today = Date()
            let fiveDaysLater = Calendar.current.date(byAdding: .day, value: 7, to: today)
            if let date = fiveDaysLater {
                
                expDateTextfield.text = formatter.string(from: date).uppercased()
            }
            
            print("7 Days")
            
        case 2:
            let today = Date()
            let fiveDaysLater = Calendar.current.date(byAdding: .day, value: 14, to: today)
            if let date = fiveDaysLater {
                
                expDateTextfield.text = formatter.string(from: date).uppercased()
            }
            
            print("14 Days")
            
        case 3:
            expDateTextfield.text = "None"
            print("Never")
            
        default:
            break
            
        }
        
        for (index,button) in expButtons.enumerated() {
            
            if index == index_ {
                button.isSelected = true
                button.backgroundColor = UIColor.red
            } else {
                button.isSelected = false
                button.backgroundColor = UIColor.lightGray
            }
        }
        
    }
    
    
    @IBAction func didPressLocationBtn(_ sender: UIButton) {
        
        selectedIndex = sender.tag
        
        switch selectedIndex {
        case 0:
            self.location = .Fridge
            print("-------Fridge btn tapped: location is \(location)")
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
        
        for (index,button) in locationButtons.enumerated() {
            if index == selectedIndex {
                button.isSelected = true
                locationViews[index].backgroundColor = MAIN_COLOR
                locationLabels[index].textColor = UIColor.white
                
               
            } else {
                button.isSelected = false
                locationViews[index].backgroundColor = UIColor.clear
                locationLabels[index].textColor = MAIN_BUTTON_LABEL_GRAY
              
            }
        }
        
    }
 

    @IBAction func cancelButtonTapped(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        saveButton.isEnabled = false
        
        guard let name = nameTextField.text, name != "" else { return }
        guard let purchaseDate = purchaseDateTextfield.text, purchaseDate != "" else { return }
        guard let expDate = expDateTextfield.text, expDate != "" else { return }
        guard let category = categoryTextfield.text, category != "" else { return }
        
        let item = Item(name: name, quantity: String(quantity), expDate: expDate, purchaseDate: purchaseDate, isConsumed: false, location: location.rawValue, category: category)
        
        let realm = try! Realm()
        try! realm.write {
            
            realm.add(item)
            print("***** \(item.name) is added to realm database in \(item.category) in \(item.location) ***** ")
            
        }
        
        showAlert()
        resetAddItems()
        

    }

   
    
    @IBAction func quantityMinusBtnTapped(_ sender: Any) {
        
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
    
    
    func formatInitialData() {
        
        nameTextField.text = ""
        tableView.isHidden = true
        categoryTextfield.text = ""
        quantity = 1
        quantityLabel.text = "\(quantity)"
        for (index,button) in locationButtons.enumerated() {
            if index == 0 {
                button.isSelected = true
                //button.backgroundColor = UIColor.green
                locationViews[index].backgroundColor = MAIN_COLOR
                locationLabels[index].textColor = UIColor.white
                
            } else {
                button.isSelected = false
                //button.backgroundColor = UIColor.clear
                locationViews[index].backgroundColor = UIColor.clear
                locationLabels[index].textColor = MAIN_BUTTON_LABEL_GRAY
            }
        }
        
        for button in expButtons {
            button.isSelected = false
            button.backgroundColor = UIColor.lightGray
        }
        
        purchaseDateTextfield.text = formatter.string(from: Date()).uppercased()
        let currentDate = Date()
        expDateTextfield.text = formatter.string(from: Date()).uppercased()
        datePicker1.setDate(currentDate, animated: false)
        datePicker2.setDate(currentDate, animated: false)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        
        if nameTextField.text != nil && nameTextField.text != "" {
            
            saveButton.isEnabled = true
            saveButton.tintColor = UIColor.red
            
            
        }
        
        
        return true
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        activeTextField = textField
        
        if textField.tag == 1 {
            
            tableView.isHidden = true
            purchaseDateTextfield.inputView = datePicker1
            datePicker1.datePickerMode = .date
            datePicker1.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
            purchaseDateTextfield.text = formatter.string(from: datePicker1.date).uppercased()
            
        } else if textField.tag == 2 {
            
            tableView.isHidden = true
            expDateTextfield.inputView = datePicker2
            datePicker2.datePickerMode = UIDatePickerMode.date
            datePicker2.addTarget(self, action: #selector(self.datePickerChanged(sender:)), for: .valueChanged)
            if let indexSelected = selectedExpIndex {
                expButtons[indexSelected].isSelected = false
            }
            
            for button in expButtons {
                button.backgroundColor = UIColor.lightGray
            }
            expDateTextfield.text = formatter.string(from: datePicker2.date).uppercased()
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        activeTextField?.resignFirstResponder()
        
        if textField == nameTextField {
            tableView.isHidden = true
            nameTextField.endEditing(true)
        }
        
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
        
        formatInitialData()
        saveButton.isEnabled = false
    
        
    }
    
}
