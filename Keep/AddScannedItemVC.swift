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

class AddScannedItemVC: UIViewController {
    
    // TODO: Custom tool bar fonts - fix!
    // TODO: Save action - notify it's actually saved
    
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
    let formatter = DateFormatter()
    var quantity = 1
    var expDate = Date()
    var purchaseDate = Date()
    var location: Location = .Fridge
    var activeTextField:UITextField?
    var isFavorited:Bool = false
    let lengthLimit = 20
    
    var itemToAdd: String? 
    
    let categories = FoodGroups.groceryCategories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustSpacing()
        nameField.delegate = self
        nameField.autocapitalizationType = .words
        expDateField.delegate = self
        pDateField.delegate = self
        categoryField.delegate = self
        formatInitialData()
        customToolBarForPickers()
        configureAppearances()
        picker.delegate = self
        picker.dataSource = self
        pDateField.inputView = datePicker1
        datePicker1.datePickerMode = .date
        expDateField.inputView = datePicker2
        datePicker2.datePickerMode = .date
        categoryField.inputView = picker
        if quantity == 1 {
            minusButton.isEnabled = false
        } else {
            minusButton.isEnabled = true
        }
        Helper.formatDates(formatter: formatter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatInitialData()
        Helper.formatDates(formatter: formatter)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originalTopMargin = topMarginConstraint.constant
    }
    
    @IBAction func minusBtnTapped(_ sender: Any) {
        minus()
    }
    
    @IBAction func plusBtnTapped(_ sender: Any) {
        plus()
    }
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        favButton.isSelected = !favButton.isSelected
        
        if favButton.isSelected {
            isFavorited = true
        } else {
            isFavorited = false
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        moveViewDown()
        categoryField.endEditing(true)
        categoryField.resignFirstResponder()
        selectedIndex = sender.tag
        switch selectedIndex {
        case 0:
            self.location = .Fridge
        case 1:
            self.location = .Freezer
        case 2:
            self.location = .Pantry
        case 3:
            self.location = .Other
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
        activeTextField?.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
    
        guard let name = nameField.text, name != EmptyString.none else { return }
        guard let quantity = quantityLabel.text, quantity != EmptyString.none else { return }
        guard let category = categoryField.text, category != EmptyString.none else { return }
        
        let uuid = UUID().uuidString
        
        let realm = try! Realm()
        try! realm.write {
            let item = Item(name: name.lowercased().capitalized, uniqueID: uuid, quantity: quantity, exp: expDate, purchaseDate: purchaseDate, location: location.rawValue, category: category)
            item.isFavorited = isFavorited
            realm.add(item)
            
            if isFavorited {
                if store.allFavoritedItems.filter({$0.name == item.name}).count == 0{
                    let favItem = FavoritedItem(name:item.name.lowercased().capitalized)
                    realm.add(favItem)
                }
                
            } else {
                if store.allFavoritedItems.filter({$0.name == item.name}).count > 0 {
                    if let itemToDelete = store.allFavoritedItems.filter({$0.name == item.name}).first {
                        realm.delete(itemToDelete)
                    }
                }
            }
        }
        
        NotificationCenter.default.post(name: NotificationName.refreshMainTV, object: nil)
        NotificationCenter.default.post(name: NotificationName.refreshScannedItems, object: nil)
        activeTextField?.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    func adjustSpacing(){
        nameField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        expDateField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        pDateField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        categoryField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
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
    
    func formatInitialData() {
        
        if let item = itemToAdd {
            nameField.text = item
        } else {
            nameField.text = store.scannedItemToAdd
        }
        
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
        let sevenDaysLater = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)
        if let date = sevenDaysLater {
            expDate = date
            expDateField.text = formatter.string(from: date).capitalized
            datePicker2.date = expDate
        }
        datePicker1.date = currentDate
    }
    
    func resetAddItems(){
        formatInitialData()
        saveButton.isEnabled = false
    }
}

extension AddScannedItemVC : KeyboardHandling {
    func moveViewUp() {
        if topMarginConstraint.constant != originalTopMargin { return }
        topMarginConstraint.constant -= 100
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func moveViewDown() {
        if topMarginConstraint.constant == originalTopMargin { return }
        topMarginConstraint.constant = originalTopMargin
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}

extension AddScannedItemVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryField.text = categories[row].rawValue
        categoryField.resignFirstResponder()
        categoryField.endEditing(true)
        moveViewDown()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].rawValue
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
    
    func donePicker(sender:UIBarButtonItem) {
        activeTextField?.resignFirstResponder()
        moveViewDown()
    }
    
    func customToolBarForPickers(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.darkGray
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: Labels.done, style: .plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: Labels.cancel, style: .plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        expDateField.inputAccessoryView = toolBar
        pDateField.inputAccessoryView = toolBar
        categoryField.inputAccessoryView = toolBar
    }
}

extension AddScannedItemVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField?.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeTextField = textField
        if textField == pDateField {
            pDateField.inputView = datePicker1
            datePicker1.datePickerMode = .date
            datePicker1.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
            pDateField.text = formatter.string(from: datePicker1.date).capitalized
            moveViewDown()
        } else if textField == expDateField {
            expDateField.inputView = datePicker2
            expDate = datePicker2.date
            datePicker2.datePickerMode = .date
            datePicker2.addTarget(self, action: #selector(self.datePickerChanged(sender:)), for: .valueChanged)
            expDateField.text = formatter.string(from: expDate).capitalized
            moveViewDown()
        } else if textField == categoryField {
            moveViewUp()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.characters.count + string.characters.count - range.length
        
        return newLength <= lengthLimit
    }
}

