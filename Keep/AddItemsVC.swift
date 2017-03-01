//
//  AddItemsVC.swift
//  Keep
//
//  Created by Luna An on 1/16/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class AddItemsVC: UIViewController, UIBarPositioningDelegate {
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet var bodyViews: [UIView]!
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
    
    var store = DataStore.sharedInstance
    var originalTopMargin:CGFloat!
    
    var location:Location = .Fridge
    var quantity: Int = 1
    var expDate = Date()
    var purchaseDate = Date()
    var category: String = "Uncategorized"
    var isFavorited = false
    var isExpired = false
    var isExpiring = false
    var isExpiringInAWeek = false
    
    var labelView: UILabel!
    let picker = UIPickerView()
    let datePicker1 = UIDatePicker()
    let datePicker2 = UIDatePicker()
    var activeTextField:UITextField?
    let formatter = DateFormatter()
    var nameTitle = EmptyString.none
    var selectedIndex: Int = 0
    var selectedExpIndex: Int?
    var allItems = Array(DataStore.sharedInstance.allItems)
    var filteredItems = [Item]()
    var filteredItemsNames = [String]()
    
    var lengthLimit = 20
    var itemToEdit:Item?
    var list = ["1","2","3","4","5","6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customToolBarForPickers()
        quantityLabel.layer.borderWidth = 1
        quantityLabel.layer.borderColor = Colors.whiteFour.cgColor
        //formatInitialData()
        
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = Colors.whiteFour.cgColor
        tableView.layer.borderWidth = 1.0
        tableView.separatorInset = .zero
        
        formatDates()
        hideKeyboard()
        tableView.isHidden = true
        picker.delegate = self
        picker.dataSource = self
        nameTextField.delegate = self
        nameTextField.autocapitalizationType = .words
        
        categoryTextfield.autocapitalizationType = .words
        categoryTextfield.delegate = self
        categoryTextfield.inputView = picker
        nameTextField.text = nameTitle
        
        nameTextField.addTarget(self, action: #selector(checkTextField(sender:)), for: .allEditingEvents)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatInitialData()
        //favButton.isSelected = isFavorited
        formatDates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originalTopMargin = topMarginConstraint.constant
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        heightConstraint.constant = 80
    }
    
    
    @IBAction func didPressFavBtn(_ sender: UIButton) {
        favButton.isSelected = !favButton.isSelected
        
        if favButton.isSelected {
            isFavorited = true
            
        } else {
            isFavorited = false
        }
    }
    
    @IBAction func didPressExpDateBtn(_ sender: UIButton) {
        let index_ = sender.tag
        
        switch index_ {
            
        case 0:
            let today = Date()
            let fiveDaysLater = Calendar.current.date(byAdding: .day, value: 5, to: today)
            if let date = fiveDaysLater {
                expDate = date
                expDateTextfield.text = formatter.string(from: date).capitalized
            }
            moveViewDown()
            print("5 Days")
            
        case 1:
            let today = Date()
            let sevenDaysLater = Calendar.current.date(byAdding: .day, value: 7, to: today)
            if let date = sevenDaysLater {
                expDate = date
                expDateTextfield.text = formatter.string(from: date).capitalized
            }
            moveViewDown()
            print("7 Days")
            
        case 2:
            let today = Date()
            let twoWeeksLater = Calendar.current.date(byAdding: .day, value: 14, to: today)
            if let date = twoWeeksLater {
                expDate = date
                expDateTextfield.text = formatter.string(from: date).capitalized
            }
            moveViewDown()
            print("14 Days")
            
        case 3:
            let today = Date()
            let neverExpire = Calendar.current.date(byAdding: .day, value: 1095, to: today)
            expDate = neverExpire! // 3 years later
            expDateTextfield.text = "None"
            moveViewDown()
            
        default:
            break
        }
        
        for (index,button) in expButtons.enumerated() {
            if index == index_ {
                button.isSelected = true
                isExpired = false
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 2
                button.layer.borderColor = Colors.tealish.cgColor
                button.setTitleColor(Colors.tealish, for: .selected)
            } else {
                button.isSelected = false
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 1
                button.layer.borderColor = Colors.warmGreyFive.cgColor
                button.setTitleColor(Colors.warmGreyThree, for: .normal)
            }
        }
    }
    
    @IBAction func didPressLocationBtn(_ sender: UIButton) {
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
        
        for (index,button) in locationButtons.enumerated() {
            if index == selectedIndex {
                button.isSelected = true
                
                button.backgroundColor = .clear
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 2
                button.layer.borderColor = Colors.tealish.cgColor
                locationLabels[index].textColor = Colors.tealish
            } else {
                button.isSelected = false
                button.backgroundColor = .clear
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.clear.cgColor
                
                locationLabels[index].textColor = Colors.warmGreyThree
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        nameTitle = EmptyString.none
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //saveButton.isEnabled = false
        guard let name = nameTextField.text else { return }
        guard let category = categoryTextfield.text else { return }
        
        let realm = try! Realm()
        if let itemToEdit = itemToEdit {
            try! realm.write {
                itemToEdit.name = name
                itemToEdit.quantity = String(quantity)
                itemToEdit.exp = expDate
                itemToEdit.purchaseDate = purchaseDate
                itemToEdit.location = location.rawValue
                itemToEdit.category = category
                itemToEdit.isFavorited = isFavorited
                itemToEdit.isExpired = isExpired
                itemToEdit.isExpiring = isExpiring
                itemToEdit.isExpiringInAWeek = isExpiringInAWeek
                
                if isFavorited {
                    if store.allFavoritedItems.filter({$0.name == itemToEdit.name}).count == 0{
                        let favItem = FavoritedItem(name:itemToEdit.name)
                        realm.add(favItem)
                        
                    }
                    
                } else {
                    if store.allFavoritedItems.filter({$0.name == itemToEdit.name}).count > 0 {
                        
                        if let itemToDelete = store.allFavoritedItems.filter({$0.name == itemToEdit.name}).first {
                            realm.delete(itemToDelete)
                            
                        }
                    }
                }
            }
            
            dismiss(animated: true, completion: nil)
            
        } else {
            let item = Item(name: name.capitalized, uniqueID: UUID().uuidString, quantity: String(self.quantity), exp: self.expDate, purchaseDate: purchaseDate, location: location.rawValue, category: category.capitalized)
            
            try! realm.write {
                
                realm.add(item)
                item.isFavorited = isFavorited
                
                let today = Date()
                var daysLeft = 0
                daysLeft = Helper.daysBetweenTwoDates(start: today, end: expDate)
                
                if daysLeft < 0 {
                    item.isExpired = true
                    item.isExpiring = false
                    item.isExpiringInAWeek = false
                    isExpired = true
                    isExpiring  = false
                    isExpiringInAWeek = false
                    
                } else if daysLeft >= 0 && daysLeft < 4  {
                    item.isExpired = false
                    item.isExpiring = true
                    item.isExpiringInAWeek = true
                    isExpired = false
                    isExpiring = true
                    isExpiringInAWeek = true
                    
                } else {
                    item.isExpired = false
                    item.isExpiring = false
                    item.isExpiringInAWeek = true
                    isExpired = false
                    isExpiring = false
                    isExpiringInAWeek = true
                }
                
                if isFavorited {
                    if store.allFavoritedItems.filter({$0.name == item.name}).count == 0{
                        let favItem = FavoritedItem(name:item.name)
                        realm.add(favItem)
                    }
                }
            }
        }
        
        resetAddItems()
        showAlert()
    }
    
    @IBAction func quantityMinusBtnTapped(_ sender: Any) {
        moveViewDown()
        if quantity == 1 {
            quantityMinusButton.isEnabled = false
        } else {
            quantityMinusButton.isEnabled = true
            quantity -= 1
            quantityLabel.text = "\(quantity)"
        }
    }
    
    @IBAction func quantityPlusBtnTapped(_ sender: Any) {
        moveViewDown()
        quantity += 1
        quantityLabel.text = "\(quantity)"
        if quantityMinusButton.isEnabled == false {
            quantityMinusButton.isEnabled = true
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func searchAutocompleteEntriesWithSubstring(_ substring: String) {
        
        filteredItemsNames.removeAll(keepingCapacity: false)
        
        for itemArray in allItems_ {
            for item in itemArray {
          
                let myString: NSString! = item as NSString
                let substringRange: NSRange! = myString.range(of: substring)
                
                if substringRange.location == 0 {
                    filteredItemsNames.append(item)
                }
            }
        }
        tableView.reloadData()
    }
    
    func formatDates(){
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
    }
    
    func showAlert() {
        labelView = UILabel(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: 40))
        labelView.backgroundColor = Colors.tealish
        if itemToEdit != nil {
            labelView.text = Labels.itemEdited
        } else {
            labelView.text = Labels.itemAdded
        }
        labelView.textAlignment = .center
        labelView.textColor = UIColor.white
        labelView.font = UIFont(name: Fonts.montserratRegular, size: 12)
        
        self.view.addSubview(labelView)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    
    func dismissAlert(){
        if labelView != nil {
            labelView.removeFromSuperview()
        }
    }
    
    func formatInitialData() {
        if let item = itemToEdit {
            nameTitle = item.name.capitalized
            category = item.category
            quantity = Int(item.quantity)!
            purchaseDate = item.purchaseDate
            expDate = item.exp
            isExpiring = item.isExpiring
            isExpired = item.isExpired
            isExpiringInAWeek = item.isExpiringInAWeek
            favButton.isSelected = item.isFavorited
            location = Location(rawValue:item.location)!
            saveButton.isEnabled = true
            saveButton.setTitleColor(Colors.tealish, for: .normal)
            
        } else {
            isFavorited = false
            isExpiringInAWeek = false
            isExpiring = false
            isExpired = false
            location = .Fridge
            let today = Date()
            let sevenDaysLater = Calendar.current.date(byAdding: .day, value: 7, to: today)
            if let date = sevenDaysLater {
                expDate = date
            }

            purchaseDate = Date()
            quantity = 1
            category = "Uncategorized"
            nameTitle = EmptyString.none
            isFavorited = false
            favButton.isSelected = false
            nameTextField.becomeFirstResponder()
            saveButton.isEnabled = false
            saveButton.setTitleColor(Colors.warmGreyThree, for: .normal)
        }
        
        tableView.isHidden = true
        nameTextField.text = nameTitle
        categoryTextfield.text = category
        quantityLabel.text = String(quantity)
        purchaseDateTextfield.text = formatter.string(from: purchaseDate).capitalized
        expDateTextfield.text = formatter.string(from: expDate).capitalized
        datePicker1.setDate(Date(), animated: false)
        datePicker2.setDate(Date(), animated: false)
        
        switch location {
        case .Fridge:
            for (i,button) in locationButtons.enumerated() {
                if i == 0 {
                    button.isSelected = true
                    button.backgroundColor = .clear
                    button.layer.cornerRadius = 5
                    button.layer.borderWidth = 2
                    button.layer.borderColor = Colors.tealish.cgColor
                    locationLabels[i].textColor = Colors.tealish
                    
                } else {
                    button.isSelected = false
                    button.backgroundColor = .clear
                    button.layer.cornerRadius = 5
                    button.layer.borderWidth = 1
                    button.layer.borderColor = UIColor.clear.cgColor
                    locationLabels[i].textColor = Colors.warmGreyThree
                }
            }
            
        case .Freezer:
            for (i,button) in locationButtons.enumerated() {
                if i == 1 {
                    button.isSelected = true
                    button.backgroundColor = .clear
                    button.layer.cornerRadius = 5
                    button.layer.borderWidth = 2
                    button.layer.borderColor = Colors.tealish.cgColor
                    locationLabels[i].textColor = Colors.tealish
                    
                } else {
                    button.isSelected = false
                    button.backgroundColor = .clear
                    button.layer.cornerRadius = 5
                    button.layer.borderWidth = 1
                    button.layer.borderColor = UIColor.clear.cgColor
                    locationLabels[i].textColor = Colors.warmGreyThree
                }
            }
            
        case .Pantry:
            for (i,button) in locationButtons.enumerated() {
                if i == 2 {
                    button.isSelected = true
                    button.backgroundColor = .clear
                    button.layer.cornerRadius = 5
                    button.layer.borderWidth = 2
                    button.layer.borderColor = Colors.tealish.cgColor
                    locationLabels[i].textColor = Colors.tealish
                    
                } else {
                    button.isSelected = false
                    button.backgroundColor = .clear
                    button.layer.cornerRadius = 5
                    button.layer.borderWidth = 1
                    button.layer.borderColor = UIColor.clear.cgColor
                    locationLabels[i].textColor = Colors.warmGreyThree
                }
            }
            
        case .Other:
            for (i,button) in locationButtons.enumerated() {
                if i == 3 {
                    button.isSelected = true
                    button.backgroundColor = .clear
                    button.layer.cornerRadius = 5
                    button.layer.borderWidth = 2
                    button.layer.borderColor = Colors.tealish.cgColor
                    locationLabels[i].textColor = Colors.tealish
                    
                } else {
                    button.isSelected = false
                    button.backgroundColor = .clear
                    button.layer.cornerRadius = 5
                    button.layer.borderWidth = 1
                    button.layer.borderColor = UIColor.clear.cgColor
                    locationLabels[i].textColor = Colors.warmGreyThree
                }
            }
        }
        
        for button in expButtons {
            button.isSelected = false
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = Colors.warmGreyThree.cgColor
            button.setTitleColor(Colors.warmGreyThree, for: .normal)
        }
    }
    
    func resetAddItems(){
        formatInitialData()
        saveButton.isEnabled = false
    }
    
}

extension AddItemsVC : KeyboardHandling {
    func moveViewUp() {
        if topMarginConstraint.constant != originalTopMargin { return }
        topMarginConstraint.constant -= 130
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

extension AddItemsVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField {
            if let text = textField.text {
                let newLength = text.characters.count + string.characters.count - range.length
                let subString = (text as NSString).replacingCharacters(in: range, with: string)
                searchAutocompleteEntriesWithSubstring(subString)
                return newLength <= lengthLimit
            }
        }
        return true
    }
    
        
    func checkTextField(sender: UITextField) {
        var textLength = 0
        if let text = sender.text {
            textLength = text.trimmingCharacters(in: .whitespacesAndNewlines).characters.count
        }
        if textLength > 0 {
            saveButton.isEnabled = true
            saveButton.titleLabel?.textColor = Colors.tealish
            
        } else {
            saveButton.isEnabled = false
            saveButton.titleLabel?.textColor = Colors.warmGreyFour
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField?.resignFirstResponder()
        activeTextField?.endEditing(true)
        moveViewDown()
        
        if textField == nameTextField {
            tableView.isHidden = true
        }
        return true
    }
    
    //    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //        if textField == categoryTextfield {
    //            textField.resignFirstResponder()
    //            return false
    //        }
    //        return true
    //    }
    //
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeTextField = textField
        if textField.tag == 1 {
            moveViewUp()
            tableView.isHidden = true
            purchaseDateTextfield.inputView = datePicker1
            datePicker1.datePickerMode = .date
            datePicker1.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
            purchaseDateTextfield.text = formatter.string(from: datePicker1.date).capitalized
            moveViewDown()
        } else if textField.tag == 2 {
            moveViewUp()
            tableView.isHidden = true
            expDateTextfield.inputView = datePicker2
            datePicker2.datePickerMode = UIDatePickerMode.date
            datePicker2.addTarget(self, action: #selector(self.datePickerChanged(sender:)), for: .valueChanged)
            if let indexSelected = selectedExpIndex {
                expButtons[indexSelected].isSelected = false
            }
            for button in expButtons {
                button.backgroundColor = .clear
                button.layer.cornerRadius = 5
                button.layer.borderWidth = 1
                button.layer.borderColor = Colors.warmGreyThree.cgColor
                button.titleLabel?.textColor = Colors.warmGreyThree
            }
            expDateTextfield.text = formatter.string(from: datePicker2.date).capitalized
        } else if textField == categoryTextfield {
            moveViewDown()
        }
    }
    
}

extension AddItemsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredItemsNames.count == 0 {
            //return allItems.count
            return list.count
        }
        return filteredItemsNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        
        nameTextField.text = selectedCell.textLabel!.text!.capitalized
        
        tableView.isHidden = !tableView.isHidden
        
        nameTextField.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Cell.nameCell)
        
        if filteredItemsNames.count == 0 {
            tableView.isHidden = true
            // ---- Dummy data ----------------------
            cell?.textLabel?.text = list[indexPath.row]
            // ---- Dummy data ----------------------
            
        } else {
            tableView.isHidden = false
            cell?.textLabel?.text = self.filteredItemsNames[indexPath.row]
        }
        
        cell?.textLabel?.font = UIFont(name: Fonts.latoRegular, size: 13)
        cell?.textLabel?.textColor = Colors.whiteFour
        return cell!
    }
}

extension AddItemsVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //self.view.endEditing(true)
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTextfield.text = list[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
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
        
        categoryTextfield.inputAccessoryView = toolBar
        expDateTextfield.inputAccessoryView = toolBar
        purchaseDateTextfield.inputAccessoryView = toolBar
    }
    
    func donePicker(sender:UIBarButtonItem) {
        view.isUserInteractionEnabled = true
        activeTextField?.resignFirstResponder()
        moveViewDown()
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        if sender == datePicker1 {
            purchaseDate = sender.date
            purchaseDateTextfield.text = formatter.string(from: sender.date).capitalized
        } else if sender == datePicker2 {
            expDate = sender.date
            expDateTextfield.text = formatter.string(from: sender.date).capitalized
        }
    }
}

extension AddItemsVC : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: tableView))! {
            return false
        } else {
            return true
        }
    }
}
