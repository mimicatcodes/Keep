//
//  AddItemVC.swift
//  Keep
//
//  Created by Luna An on 1/6/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class AddItemVC: UIViewController, UITextFieldDelegate {
 // To do: autocomplete?
    let store = DataStore.sharedInstance
    var listTitle:String?
    var uniqueID: String?
    
    @IBOutlet weak var saveButton: CustomButton!
    @IBOutlet weak var createItemView: UIView!
    @IBOutlet weak var itemTitleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        saveButton.isEnabled = false
        saveButton.backgroundColor = .red
        itemTitleField.delegate = self
        itemTitleField.becomeFirstResponder()
        itemTitleField.autocapitalizationType = .words
        itemTitleField.addTarget(self, action: #selector(checkTextField(sender:)), for: .editingChanged)
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        save()
    }
    
    func save() {
        guard let title = itemTitleField.text, !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let shoppingItem = ShoppingItem(name: title, isPurchased: false)
        
        guard let id = uniqueID else { return }
        
        let predicate = NSPredicate(format: Filters.uniqueID, id)
        let filteredList = store.allShopingLists.filter(predicate).first
        shoppingItem.list = filteredList
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(shoppingItem)
            shoppingItem.list?.numOfItems += 1
        }
        NotificationCenter.default.post(name: NotificationName.refreshItemList, object: nil)
        dismiss()
    }
    
    func checkTextField(sender: UITextField) {
        var textLength = 0
        if let text = sender.text {
            textLength = text.trimmingCharacters(in: .whitespacesAndNewlines).characters.count
        }
        if textLength > 0 {
            saveButton.isEnabled = true
            saveButton.backgroundColor = Colors.main
            
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .red
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        save()
        return true
    }
    
    func dismiss() {
        itemTitleField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }

    func setupViews(){
        view.backgroundColor = Colors.dawn
    }
}
