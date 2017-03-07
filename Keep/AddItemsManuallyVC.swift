//
//  AddItemsManuallyVC.swift
//  Keep
//
//  Created by Luna An on 3/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class AddItemsManuallyVC: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    // Fill category logic - apply to other vc
    // seperate tv alements from vc
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityLabel: CustomLabel!
    @IBOutlet weak var quantityMinusButton: UIButton!
    @IBOutlet weak var quantityPlusButton: UIButton!
    @IBOutlet weak var purchaseDateField: UITextField!
    @IBOutlet weak var expDateField: UITextField!
    @IBOutlet weak var fridgeButton: UIButton!
    @IBOutlet weak var freezerButton: UIButton!
    @IBOutlet weak var pantryButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var categoryField: CategoryField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var labelView: UILabel!
    var locationButtons:[UIButton] = []
    var originTopMargin: CGFloat!
    
    let realm = try! Realm()
    let store = DataStore.sharedInstance
    var nameTitle = EmptyString.none
    var location:Location = .Fridge
    var quantity: Int = 1
    var expDate = Date()
    var purchaseDate = Date()
    var isFavorited = false
    var category: String = "Other"
    let today = Date()
    
    let picker = UIPickerView()
    let datePickerOne = UIDatePicker()
    let datePickerTwo = UIDatePicker()
    let formatter = DateFormatter()
    
    var activeTextField:UITextField?
    let lengthLimit = 23
    var selectedIndex = 0
    
    var itemToEdit: Item?
    let categories = FoodGroups.groceryCategories
    
    var allItems = Array(DataStore.sharedInstance.allItems)
    var filteredItemsNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationButtons = [fridgeButton, freezerButton, pantryButton, otherButton]
        formatInitialData()
        customToolBarForPickers()
        nameTextField.addTarget(self, action: #selector(checkTextField(sender:)), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(fillCategory), for: .allEditingEvents)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatInitialData()
        Helper.formatDates(formatter: formatter)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originTopMargin = topMarginConstraint.constant
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        activeTextField?.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let name = nameTextField.text else { return }
        guard let category = categoryField.text else { return }
        
        if let item = itemToEdit {
            try! realm.write {
                item.name = name
                item.quantity = String(quantity)
                item.exp = expDate
                item.purchaseDate = purchaseDate
                item.location = location.rawValue
                item.category = category
                configureExpires(item: item)
                configureFavorites(item: item)
                deleteFavorites(item: item)
            }
            
            dismiss(animated: true, completion: nil)
            
        } else {
            let item = Item(name: name.capitalized, uniqueID: UUID().uuidString, quantity: String(self.quantity), exp: expDate, purchaseDate: purchaseDate, location: location.rawValue, category: category)
            
            try! realm.write {
                configureExpires(item: item)
                configureFavorites(item: item)
                realm.add(item)
            }
        }
        
        NotificationCenter.default.post(name: NotificationName.refreshCharts, object: nil)
        activeTextField?.endEditing(true)
        resetView()
        showAlert()
    }
    
    @IBAction func favoriteBtnTapped(_ sender: Any) {
        tableView.isHidden = true
        favoriteButton.isSelected = !favoriteButton.isSelected
        
        if favoriteButton.isSelected {
            isFavorited = true
        } else {
            isFavorited = false
        }
    }
    
    @IBAction func minustBtnTapped(_ sender: Any) {
        tableView.isHidden = true
        if quantity > 1 {
            quantity -= 1
        } else {
            quantityMinusButton.isEnabled = false
        }
        
        quantityLabel.text = "\(quantity)"
    }
    
    @IBAction func plusBtnTapped(_ sender: Any) {
        tableView.isHidden = true
        quantity += 1
        quantityLabel.text = "\(quantity)"
        if quantity > 1 {
            quantityMinusButton.isEnabled = true
        }
    }
    
    @IBAction func locationBtnTapped(_ sender: UIButton) {
        tableView.isHidden = true
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
        configureLocationButtons()
    }
    
    
    func formatInitialData(){
        adjustSpacing()
        configureAppearances()
        configureTableView()
        if let item = itemToEdit {
            nameTitle = item.name.capitalized
            category = item.category
            quantity = Int(item.quantity)!
            purchaseDate = item.purchaseDate
            expDate = item.exp
            favoriteButton.isSelected = item.isFavorited
            location = Location(rawValue:item.location)!
            switch location {
            case .Fridge:
                selectedIndex = 0
            case .Freezer:
                selectedIndex = 1
            case .Pantry:
                selectedIndex = 2
            case .Other:
                selectedIndex = 3
            }
            saveButton.isEnabled = true
            saveButton.setTitleColor(Colors.tealish, for: .normal)
            
        } else {
            resetView()
        }
        
        configureTextfields()
        configurePickerSettings()
        configureQuantityButtons()
        configureLocationButtons()
        Helper.formatDates(formatter: formatter)
    }
    
    func configureFavorites(item: Item) {
        item.isFavorited = isFavorited
        if isFavorited {
            if store.allFavoritedItems.filter({$0.name == item.name}).count == 0{
                let favItem = FavoritedItem(name:item.name)
                realm.add(favItem)
            }
        }
    }
    
    func deleteFavorites(item:Item){
        if !isFavorited {
            if store.allFavoritedItems.filter({$0.name == item.name}).count > 0 {
                if let itemToDelete = store.allFavoritedItems.filter({$0.name == item.name}).first {
                    realm.delete(itemToDelete)
                }
            }
        }
    }
    
    func configureExpires(item: Item){
        var daysLeft = 0
        daysLeft = Helper.daysBetweenTwoDates(start: today, end: item.exp)
        
        if daysLeft < 0 {
            item.isExpired = true
            item.isExpiring = false
            item.isExpiringInAWeek = false
            
        } else if daysLeft >= 0 && daysLeft < 4  {
            item.isExpired = false
            item.isExpiring = true
            item.isExpiringInAWeek = true

        } else {
            item.isExpired = false
            item.isExpiring = false
            item.isExpiringInAWeek = true
        }
    }
    
    func configureTextfields(){
        nameTextField.text = nameTitle
        quantityLabel.text = String(quantity)
        purchaseDateField.text = formatter.string(from: purchaseDate).capitalized
        expDateField.text = formatter.string(from: expDate).capitalized
        categoryField.text = category
    }
    
    func configureQuantityButtons(){
        if quantity == 1 {
            quantityMinusButton.isEnabled = false
        } else {
            quantityMinusButton.isEnabled = true
        }
    }
    
    func configurePickerSettings(){
        categoryField.inputView = picker
        picker.delegate = self
        picker.dataSource = self
        datePickerOne.datePickerMode = .date
        datePickerTwo.datePickerMode = .date
        datePickerOne.date = Date()
        datePickerTwo.date = expDate
    }
    
    
    func configureLocationButtons() {
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
    
    func configureTableView(){
        tableView.allowsSelection = true
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 8
        tableView.layer.borderColor = Colors.whiteFour.cgColor
        tableView.layer.borderWidth = 1.0
        tableView.separatorInset = .zero
        tableView.isHidden = true
    }
    
    func adjustSpacing(){
        nameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        expDateField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        purchaseDateField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        categoryField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
    }
    
    func configureAppearances(){
        nameTextField.layer.cornerRadius = 8
        quantityLabel.layer.cornerRadius = 8
        quantityLabel.layer.masksToBounds = true
        purchaseDateField.layer.cornerRadius = 8
        expDateField.layer.cornerRadius = 8
        locationView.layer.cornerRadius = 8
        categoryField.layer.cornerRadius = 8
    }
    
    func showAlert() {
        labelView = UILabel(frame: CGRect(x: 0, y: 70, width: self.view.frame.width, height: 40))
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
        
        Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    
    func dismissAlert(){
        if labelView != nil {
            labelView.removeFromSuperview()
        }
    }
    
    func resetView(){
        tableView.isHidden = true
        nameTextField.text = EmptyString.none
        nameTextField.autocapitalizationType = .words
        nameTextField.becomeFirstResponder()
        quantity = 1
        quantityLabel.text = "1"
        isFavorited = false
        favoriteButton.isSelected = false
        purchaseDate = today
        datePickerOne.setDate(purchaseDate, animated: true)
        let sevenDaysLater = Calendar.current.date(byAdding: .day, value: 7, to: today)
        if let date = sevenDaysLater {
            expDate = date
            datePickerTwo.setDate(expDate, animated: true)
        }
        purchaseDateField.text = formatter.string(from: purchaseDate).capitalized
        expDateField.text = formatter.string(from: expDate).capitalized

        picker.selectRow(0, inComponent: 0, animated: true)
        categoryField.text = "Other"

        location = .Fridge
        selectedIndex = 0
        configureLocationButtons()
        
        saveButton.isEnabled = false
        saveButton.setTitleColor(Colors.warmGreyThree, for: .normal)
    }
    
    func checkTextField(sender: UITextField) {
        var textLength = 0
        if let text = sender.text {
            textLength = text.trimmingCharacters(in: .whitespacesAndNewlines).characters.count
        }
        
        if textLength > 0 {
            saveButton.isEnabled = true
            saveButton.setTitleColor(Colors.tealish, for: .normal)
            
        } else {
            saveButton.isEnabled = false
            saveButton.setTitleColor(Colors.warmGreyFour, for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredItemsNames.count == 0 {
            return allItems.count
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
        } else {
            tableView.isHidden = false
            cell?.textLabel?.text = self.filteredItemsNames[indexPath.row]
        }
        cell?.textLabel?.font = UIFont(name: Fonts.latoRegular, size: 13)
        cell?.textLabel?.textColor = Colors.tealishFaded
        
        return cell!
    }
    
    func searchAutocompleteEntriesWithSubstring(_ substring: String) {
        
        filteredItemsNames.removeAll(keepingCapacity: false)
        
        for itemArray in FoodItems.all {
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
    
    func fillCategory(){
        print("-------------------------------------------------------------")
        guard let name = nameTextField.text else { return }
        
        for foodGroup in foodGroups {
            for (key, value) in foodGroup {
                if value.contains(name) {
                    DispatchQueue.main.async {
                        self.categoryField.text = key
                    }
                } else {
                    self.categoryField.text = "Other"
                }
            }
        }
    }
}


extension AddItemsManuallyVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField?.resignFirstResponder()
        activeTextField?.endEditing(true)
        moveViewDown()
        
        if textField == nameTextField {
            tableView.isHidden = true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeTextField = textField
        if activeTextField != nameTextField {
            tableView.isHidden = true
        }
        
        if textField == purchaseDateField {
            purchaseDateField.inputView = datePickerOne
            datePickerOne.datePickerMode = .date
            datePickerOne.addTarget(self, action: #selector(self.datePickerChanged(sender:)) , for: .valueChanged)
            purchaseDateField.text = formatter.string(from: datePickerOne.date).capitalized
            moveViewDown()
        } else if textField == expDateField {
            expDateField.inputView = datePickerTwo
            datePickerTwo.datePickerMode = UIDatePickerMode.date
            datePickerTwo.addTarget(self, action: #selector(self.datePickerChanged(sender:)), for: .valueChanged)
            expDateField.text = formatter.string(from: datePickerTwo.date).capitalized
            moveViewDown()
        } else if textField == categoryField {
            moveViewUp()
        }
    }
    
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
}

extension AddItemsManuallyVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryField.text = categories[row].rawValue
        if activeTextField == categoryField {
            pickerView.reloadAllComponents()
            
        }
        categoryField.resignFirstResponder()
        categoryField.endEditing(true)
        moveViewDown()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].rawValue
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        if sender == datePickerOne {
            purchaseDate = sender.date
            purchaseDateField.text = formatter.string(from: sender.date).capitalized
        } else if sender == datePickerTwo {
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
        purchaseDateField.inputAccessoryView = toolBar
        categoryField.inputAccessoryView = toolBar
    }
}

extension AddItemsManuallyVC : KeyboardHandling {
    func moveViewDown() {
        if topMarginConstraint.constant == originTopMargin { return }
        topMarginConstraint.constant = originTopMargin
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func moveViewUp() {
        if topMarginConstraint.constant != originTopMargin { return }
        topMarginConstraint.constant -= 100
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}

