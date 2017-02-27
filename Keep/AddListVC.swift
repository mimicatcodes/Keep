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

class AddListVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var listTitle: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var createListView: UIView!
    
    var listToEdit: ShoppingList?
    
    let store = DataStore.sharedInstance
    let currentDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTitle.delegate = self
        hideKeyboard()
        setupViews()
        listTitle.becomeFirstResponder()
        saveButton.isEnabled = false
        listTitle.autocapitalizationType = .words
        saveButton.backgroundColor = Colors.whiteTwo
        saveButton.setTitleColor(Colors.tealish, for: .normal)
        initialSetting()
        listTitle.addTarget(self, action: #selector(checkTextField(sender:)), for: .editingChanged)
    }
    
    func initialSetting(){
        if let list = listToEdit {
            listTitle.text = list.title
            
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        //dismiss()
    }
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        save()
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss()
    }
    
    func setupViews(){
        view.backgroundColor = Colors.dawn
    }
    
    func dismiss() {
        listTitle.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        guard let text = listTitle.text, !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else { return }
        
        if let listToEdit = listToEdit {
            let realm = try! Realm()
            try! realm.write {
                listToEdit.title = text
            }
        } else {
            let list = ShoppingList(title: text, isCreatedAt: currentDate)
            let uuid = UUID().uuidString
            list.uniqueID = uuid
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(list)
            }
        }
        
        NotificationCenter.default.post(name: NotificationName.refreshTableview, object: nil)
        dismiss()
    }
    
    func checkTextField(sender: UITextField) {
        
        var textLength = 0
        
        if let text = sender.text {
            textLength = text.trimmingCharacters(in: .whitespacesAndNewlines).characters.count
        }
        if textLength > 0 {
            saveButton.isEnabled = true
            saveButton.backgroundColor = Colors.tealish
            saveButton.setTitleColor(.white, for: .normal)
            
        } else {
            saveButton.isEnabled = false
            saveButton.setTitleColor(Colors.tealish, for: .normal)
            saveButton.backgroundColor = Colors.whiteTwo
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // change to done
        save()
        return true
    }
}


