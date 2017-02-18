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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupViews()
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
        
        let shoppingItem = ShoppingItem(name: title, isPurchased: false)
        
        guard let id = uniqueID else { return }
        
        let predicate = NSPredicate(format: "uniqueID contains[c] %@", id)
        let filteredList = store.allShopingLists.filter(predicate).first
        shoppingItem.list = filteredList
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(shoppingItem)
            shoppingItem.list?.numOfItems += 1
        }
        
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NotificationName.refreshItemList, object: nil)
        
    }

    func setupViews(){
        view.backgroundColor = Colors.dawn
    }
}
