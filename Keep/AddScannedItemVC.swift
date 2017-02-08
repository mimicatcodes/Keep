//
//  AddScannedItemVC.swift
//  Keep
//
//  Created by Mirim An on 2/8/17.
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
       NotificationCenter.default.post(name: REFRESH_SCANNED_ITEMS, object: nil)
    
        dismiss(animated: true, completion: nil)
    }

}
