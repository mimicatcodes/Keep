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
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var notApplicableButton: UIButton!
    @IBOutlet var locationView: UIView!
    @IBOutlet var locationButtons: [UIButton]!
    @IBOutlet weak var expDateField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var labelView: UILabel!

    let store = DataStore.sharedInstance
    let realm = try! Realm()
    var originalTopMargin: CGFloat!
    
    let picker = UIPickerView()
    let datePicker = UIDatePicker()
    
    var selectedIndex: Int = 0
    let formatter = DateFormatter()
    var quantity = 1
    var expDate = Date()
    var addedDate = Date()
    var location: Location = .Fridge
    var activeTextField:UITextField?
    var isFavorited:Bool = false
    let lengthLimit = 23
    var category: String = FoodCategories.other.rawValue
    
    var itemToAdd: String?
    var isFromFavorite: Bool?
    
    let today = Date()
    let categories = FoodGroups.groceryCategories
    
    var filteredItemsNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustSpacing()
        Helper.configureTableView(tableView: tableView)
        configureAppearances()
        configurePickers()
        setDelegatesForTextfields()
        formatInitialData()
        customToolBarForPickers()
        checkTextfields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatInitialData()
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
        tableView.isHidden = true
        favButton.isSelected = !favButton.isSelected
        
        if favButton.isSelected {
            isFavorited = true
        } else {
            isFavorited = false
        }
    }
    
    @IBAction func naBtnTapped(_ sender: Any) {
        tableView.isHidden = true
        notApplicableButton.isSelected = !notApplicableButton.isSelected
        if notApplicableButton.isSelected {
            expDateField.text = Labels.na
            let hundressYearsLater = Calendar.current.date(byAdding: .year, value: 100, to: today)
            if let date = hundressYearsLater {
                expDate = date
            }
        } else {
            let sevenDaysLater = Calendar.current.date(byAdding: .day, value: 7, to: today)
            if let date = sevenDaysLater {
                expDate = date
                datePicker.setDate(expDate, animated: true)
                expDateField.text = formatter.string(from: expDate).capitalized
            }
        }
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
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
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        guard let name = nameField.text, name != EmptyString.none else { return }

        let uuid = UUID().uuidString
        
        try! realm.write {
            let item = Item(name: name.lowercased().capitalized, uniqueID: uuid, quantity: String(quantity), exp: expDate, addedDate: addedDate, location: location.rawValue, category: category)
            realm.add(item)
            configureFavorites(item: item)
            deleteFavorites(item: item)
        }
        
        NotificationCenter.default.post(name: NotificationName.refreshMainTV, object: nil)
        NotificationCenter.default.post(name: NotificationName.refreshScannedItems, object: nil)
        
        view.endEditing(true)
        showAlert(itemName: name)
    }
    
    func checkTextfields(){
        nameField.addTarget(self, action: #selector(checkTextField(sender:)), for: .editingChanged)
        categoryField.addTarget(self, action: #selector(checkTextField(sender:)), for: .editingChanged)
        nameField.addTarget(self, action: #selector(fillCategory), for: .allEditingEvents)
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
    
    func configureLocationButtons(){
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
    
    func setDelegatesForTextfields(){
        nameField.delegate = self
        expDateField.delegate = self
        categoryField.delegate = self
    }
    
    func configurePickers(){
        picker.delegate = self
        picker.dataSource = self
        expDateField.inputView = datePicker
        datePicker.datePickerMode = .date
        categoryField.inputView = picker
    }
    
    func fillCategory(){
        guard let name = nameField.text else { return }
        
        for foodGroup in foodGroups {
            for (key, value) in foodGroup {
                if value.contains(name) {
                    DispatchQueue.main.async {
                        self.category = key
                        self.categoryField.text = key
                    }
                } else {
                    self.category = FoodCategories.other.rawValue
                    self.categoryField.text = FoodCategories.other.rawValue
                }
            }
        }
    }
    
    func adjustSpacing(){
        nameField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        expDateField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
        categoryField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0)
    }
    
    func configureAppearances(){
        nameField.layer.cornerRadius = 8
        quantityLabel.layer.cornerRadius = 8
        quantityLabel.layer.masksToBounds = true
        expDateField.layer.cornerRadius = 8
        locationView.layer.cornerRadius = 8
        categoryField.layer.cornerRadius = 8
    }
    
    func minus(){
        tableView.isHidden = true
        if quantity == 1 {
            minusButton.isEnabled = false
        } else {
            plusButton.isEnabled = true
            quantity -= 1
            quantityLabel.text = "\(quantity)"
        }
    }
    
    func plus(){
        tableView.isHidden = true
        quantity += 1
        quantityLabel.text = "\(quantity)"
        if minusButton.isEnabled == false {
            minusButton.isEnabled = true
        }
    }
    
    func formatInitialData() {
        tableView.isHidden = true
        if let item = itemToAdd {
            nameField.text = item
            
        } else {
            nameField.text = store.scannedItemToAdd
        }
        
        if isFromFavorite != nil {
            isFavorited = true
            favButton.isSelected = true
        }
        
        fillCategory()
        configureLocationButtons()
        configureTextFields()
        configureQuantityButtons()
        configurePickersDates()
        
        saveButton.isEnabled = true
        saveButton.setTitleColor(Colors.tealish, for: .normal)
        
        Helper.formatDates(formatter: formatter)
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
            tableView.isHidden = true
            saveButton.isEnabled = false
            saveButton.setTitleColor(Colors.warmGreyFour, for: .normal)
        }
        
        if sender == categoryField {
            if let c = sender.text {
                for c_ in categories {
                    if c != c_.rawValue {
                        sender.text = FoodCategories.other.rawValue
                        category = FoodCategories.other.rawValue
                    }
                }
            }
        }
    }
    
    func configurePickersDates(){
        let sevenDaysLater = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        if let date = sevenDaysLater {
            expDate = date
            datePicker.setDate(expDate, animated: true)
        }
        picker.selectRow(0, inComponent: 0, animated: true)
    }
    
    func configureNA(){
        let calendar = Calendar.current
        let yearComponent = calendar.component(.year, from: expDate)
        
        if yearComponent > 2100 {
            expDateField.text = Labels.na
            notApplicableButton.isSelected = true
        } else {
            expDateField.text = formatter.string(from: expDate).capitalized
            notApplicableButton.isSelected = false
        }
    }
    
    func configureTextFields(){
        nameField.autocapitalizationType = .words
        if let item = itemToAdd {
            nameField.text = item
        } else {
            nameField.text = store.scannedItemToAdd
        }
        quantity = 1
        quantityLabel.text = String(quantity)
        
        configureNA()
        //categoryField.text = category
    }
    
    func configureQuantityButtons(){
        if quantity == 1 {
            minusButton.isEnabled = false
        } else {
            minusButton.isEnabled = true
        }
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
    
    func showAlert(itemName:String) {
        labelView = UILabel(frame: CGRect(x: 0, y: 70, width: self.view.frame.width, height: 40))
        labelView.backgroundColor = Colors.tealish
        labelView.text = Labels.itemAdded + " to \(location.rawValue)"
        labelView.textAlignment = .center
        labelView.textColor = UIColor.white
        labelView.font = UIFont(name: Fonts.montserratRegular, size: 12)
        
        self.view.addSubview(labelView)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    
    func dismissAlert(){
        if labelView != nil {
            labelView.removeFromSuperview()
        }
        //view.endEditing(true)
        dismiss(animated: true, completion: nil)
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
        category = categories[row].rawValue
        categoryField.text = categories[row].rawValue
        if activeTextField == categoryField {
            pickerView.reloadAllComponents()
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].rawValue
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        if sender == datePicker {
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
        categoryField.inputAccessoryView = toolBar
    }
}

extension AddScannedItemVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeTextField?.resignFirstResponder()
        tableView.isHidden = true
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeTextField = textField
        
        if activeTextField != nameField {
            tableView.isHidden = true
        }
        
        if textField == expDateField {
            expDateField.inputView = datePicker
            expDate = datePicker.date
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(self.datePickerChanged(sender:)), for: .valueChanged)
            expDateField.text = formatter.string(from: expDate).capitalized
            notApplicableButton.isSelected = false
            moveViewDown()
        } else if textField == categoryField {
            moveViewUp()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameField {
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

extension AddScannedItemVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredItemsNames.count == 0 {
            tableView.isHidden = true
            return 0
        }
        tableView.isHidden = false
        return filteredItemsNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        nameField.text = selectedCell.textLabel!.text!.capitalized
        tableView.isHidden = !tableView.isHidden
        nameField.endEditing(true)
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
        cell?.textLabel?.textColor = Colors.tealish
        
        return cell!
    }
}
