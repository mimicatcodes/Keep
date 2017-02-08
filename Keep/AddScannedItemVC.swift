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

    let store = DataStore.sharedInstance
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet var locationButtons: [UIButton]!
    @IBOutlet weak var expDateField: UITextField!
    @IBOutlet weak var pDateField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var expDate = Date()
    var purchaseDate = Date()
    var location: Location = .Fridge
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.text = store.scannedItemToAdd
    }
    
    @IBAction func favButtonTapped(_ sender: Any) {
    }
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let name = nameField.text, name != "" else { return }
        guard let quantity = quantityLabel.text, quantity != "" else { return }
        //guard let expDate = expDateField.text, expDate != "" else { return }
        //guard let purchaseDate = pDateField.text, purchaseDate != "" else { return }
        guard let category = categoryField.text, category != "" else { return }
        
        let realm = try! Realm()
        try! realm.write {
          let item = Item(name: name, quantity: quantity, exp: expDate, purchaseDate: purchaseDate, isConsumed: false, location: location.rawValue, category: category)
            print("scanned item to add to realm is \(item)")
            realm.add(item)
        }
        
       NotificationCenter.default.post(name: REFRESH_SCANNED_ITEMS, object: nil)
        
    
        dismiss(animated: true, completion: nil)
    }

}
