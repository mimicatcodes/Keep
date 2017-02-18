//
//  AddListVC.swift
//  Keep
//
//  Created by Luna An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift
import NotificationCenter

class AddListVC: UIViewController,  UITextFieldDelegate {
            
    let store = DataStore.sharedInstance
    let currentDate = Date()
    
    @IBOutlet weak var listTitle: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var createListView: UIView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        listTitle.delegate = self
        customToolBarForPickers()
        hideKeyboard()
        setupViews()
        saveButton.isEnabled = false
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        
        guard let title = listTitle.text, title != "" else { return }
        let list = ShoppingList(title: title, isCreatedAt: currentDate)
        let uuid = UUID().uuidString
        list.uniqueID = uuid
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(list)
            print("\(list.title) is added on \(list.isCreatedAt) at \(list.shoppingItems)")
        }
        
        print("Add button tapped")
        NotificationCenter.default.post(name: NotificationName.refreshTableview, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        enableSaveButton()
        return true
    }
    
    func enableSaveButton(){
        
        guard let title = listTitle.text, title != "" else { return }

        saveButton.isEnabled = true
        saveButton.backgroundColor = UIColor.cyan
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
        listTitle.inputAccessoryView = toolBar
        
    }
    
    func donePicker(sender:UIBarButtonItem){
        listTitle.resignFirstResponder()
    }

    func setupViews(){
        view.backgroundColor = Colors.dawn
    }
}
