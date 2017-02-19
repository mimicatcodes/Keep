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

class AddScannedItemVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIBarPositioningDelegate, UINavigationControllerDelegate  {
    
    // TODO: fix pickers - date errors
    // TODO: Custom tool bar fonts - fix!
    
    //let store = DataStore.sharedInstance
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet var locationView: UIView!
    @IBOutlet var locationButtons: [UIButton]!
    @IBOutlet weak var expDateField: UITextField!
    @IBOutlet weak var pDateField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    let store = DataStore.sharedInstance
    var originalTopMargin: CGFloat!
    let picker = UIPickerView()
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
    
    // dummy data
    let categories = ["1","2","3","4","5","6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        nameField.autocapitalizationType = .words
        expDateField.delegate = self
        pDateField.delegate = self
        categoryField.delegate = self
        categoryField.autocapitalizationType = .words
        formatInitialData()
        customToolBarForPickers()
        configureAppearances()
        picker.delegate = self
        picker.dataSource = self
        pDateField.inputView = datePicker1
        expDateField.inputView = datePicker2
        categoryField.inputView = picker
        if quantity == 1 {
            minusButton.isEnabled = false
        } else {
            minusButton.isEnabled = true
        }
        formatDates()
    }
    
    /*func customFontForBarButtonItems(left: UIBarButtonItem, right: UIBarButtonItem){
        if let font = UIFont(name: Fonts.latoSemibold, size: 15) {
            left.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
            right.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
        }
    }*/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = store.scannedItemToAdd
        formatInitialData()
        formatDates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originalTopMargin = topMarginConstraint.constant
    }
    
    func configureAppearances(){
        nameField.layer.cornerRadius = 8
        quantityLabel.layer.cornerRadius = 8
        quantityLabel.layer.masksToBounds = true
        pDateField.layer.cornerRadius = 8
        expDateField.layer.cornerRadius = 8
        locationView.layer.cornerRadius = 8
        categoryField.layer.cornerRadius = 8
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryField.text = categories[row]
        categoryField.resignFirstResponder()
        categoryField.endEditing(true)
        moveViewDown()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    @IBAction func minusBtnTapped(_ sender: Any) {
        minus()
    }
    
    @IBAction func plusBtnTapped(_ sender: Any) {
        plus()
    }
    
    func minus(){
        if quantity == 1 {
            minusButton.isEnabled = false
        } else {
            plusButton.isEnabled = true
            quantity -= 1
            quantityLabel.text = "\(quantity)"
        }
    }
    
    func plus(){
        quantity += 1
        quantityLabel.text = "\(quantity)"
        if minusButton.isEnabled == false {
            minusButton.isEnabled = true
        }
    }
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        
        // toggle status here
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        
        moveViewDown()
        categoryField.endEditing(true)
        categoryField.resignFirstResponder()
        selectedIndex = sender.tag
        switch selectedIndex {
        case 0:
            self.location = .Fridge
            print(Locations.fridge)
        case 1:
            self.location = .Freezer
            print(Locations.freezer)
        case 2:
            self.location = .Pantry
            print(Locations.pantry)
        case 3:
            self.location = .Other
            print(Locations.other)
        default:
            break
        }
        
        for (index, button) in locationButtons.enumerated() {
            if index == selectedIndex {
                button.isSelected = true
                button.backgroundColor = Colors.tealish
                button.setTitleColor(.white, for: .selected)
                button.layer.cornerRadius = 5
            } else {
                button.isSelected = false
                button.backgroundColor = Colors.whiteTwo
                button.setTitleColor(Colors.tealish, for: .normal)
                button.layer.cornerRadius = 5
            }
        }
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        
         dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        
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
          NotificationCenter.default.post(name: NotificationName.refreshMainTV, object: nil)
        NotificationCenter.default.post(name: NotificationName.refreshScannedItems, object: nil)
        dismiss(animated: true, completion: nil)
    }
  
    
    
    func formatInitialData() {

        categoryField.text = "Other"
        quantity = 1
        quantityLabel.text = "\(quantity)"
        
        for (index,button) in locationButtons.enumerated() {
            if index == 0 {
                button.isSelected = true
                button.backgroundColor = Colors.tealish
                button.setTitleColor(.white, for: .selected)
                button.layer.cornerRadius = 5
            } else {
                button.isSelected = false
                button.backgroundColor = Colors.whiteTwo
                button.setTitleColor(Colors.tealish, for: .normal)
                button.layer.cornerRadius = 5
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
        categoryField.inputAccessoryView = toolBar
    }


    func donePicker(sender:UIBarButtonItem) {
        
        activeTextField?.resignFirstResponder()
            moveViewDown()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        activeTextField = textField
        print("???????????\(activeTextField)")
        
        if textField.tag == 0 {
            
            pDateField.inputView = datePicker1
            datePicker1.datePickerMode = .date
            datePicker1.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
            pDateField.text = formatter.string(from: datePicker1.date).capitalized
            moveViewDown()
            
        } else if textField.tag == 1 {
            
            expDateField.inputView = datePicker2
            datePicker2.datePickerMode = UIDatePickerMode.date
            datePicker2.addTarget(self, action: #selector(self.datePickerChanged(sender:)), for: .valueChanged)
            expDateField.text = formatter.string(from: datePicker2.date).capitalized
            moveViewDown()
        } else if textField.tag == 2 {
            moveViewUp()
        }
    }

    func moveViewUp() {
        if topMarginConstraint.constant != originalTopMargin {
            return
        }
        topMarginConstraint.constant -= 100
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func moveViewDown() {
        if topMarginConstraint.constant == originalTopMargin {
            return
        }
        topMarginConstraint.constant = originalTopMargin
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}

