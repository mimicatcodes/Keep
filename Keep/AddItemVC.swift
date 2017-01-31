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

class AddItemVC: UIViewController {
    
    // TO DO: picker, autocomplete textfield
    
    let store = DataStore.sharedInstance
    
    @IBOutlet weak var createItemView: UIView!
    var listTitle:String?
    var uniqueID: String?

    @IBOutlet weak var itemTitleField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupViews()
        quantityField.text = "1"
        itemTitleField.autocapitalizationType = .words

    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        guard let title = itemTitleField.text, title != "" else { return }
        guard let quantity = quantityField.text, quantity != "" else { return }
        
        let shoppingItem = ShoppingItem(name: title, quantity: quantity, isPurchased: false)
        
        guard let id = uniqueID else { return }
        
        let predicate = NSPredicate(format: "uniqueID contains[c] %@", id)
        let filteredList = store.allShopingLists.filter(predicate).first
        shoppingItem.list = filteredList
        
        let realm = try! Realm()
        try! realm.write {
            
            realm.add(shoppingItem)
            shoppingItem.list?.numOfItems += 1
            print("***** \(shoppingItem.name) is added to realm database in \(shoppingItem.list?.uniqueID) in \(shoppingItem.quantity) ***** ")
        }
        
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: REFRESH_ITEM_LIST_NOTIFICATION, object: nil)
        
    }
    
    
    func setupViews(){
        
        view.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.35)
        createItemView.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.00)
    }
    
    
}
