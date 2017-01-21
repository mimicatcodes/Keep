//
//  AddItemsVC.swift
//  Keep
//
//  Created by Luna An on 1/16/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class AddItemsVC: UIViewController, UITextFieldDelegate {
    
    var store = DataStore.sharedInstance
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var quantityTextfield: UITextField!
    @IBOutlet weak var purchaseDateTextfield: UITextField!
    @IBOutlet weak var expDateTextfield: UITextField!
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var categoryTextfield: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        saveButton.isEnabled = false
    
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        saveButton.isEnabled = false
        
        guard let name = nameTextfield.text, name != "" else { return }
        guard let quantity = quantityTextfield.text, quantity != "" else { return }
        guard let purchaseDate = purchaseDateTextfield.text, purchaseDate != "" else { return }
        guard let expDate = expDateTextfield.text, expDate != "" else { return }
        guard let location = locationTextfield.text, location != "" else { return }
        guard let category = categoryTextfield.text, category != "" else { return }
        
        let item = Item(name: name, quantity: quantity, expDate: expDate, purchaseDate: purchaseDate, isConsumed: false, location: location, category: category)
        
        let realm = try! Realm()
        
        try! realm.write {
            
            realm.add(item)
            print("***** \(item.name) is added to realm database in \(item.category) ***** ")

        }
        
        let _ = navigationController?.popViewController(animated: true)
    }
    
  
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        if nameTextfield.text != nil && nameTextfield.text != "" {
            
            saveButton.isEnabled = true
            saveButton.backgroundColor = UIColor.cyan
            
        }
        
        return true
    }

}

