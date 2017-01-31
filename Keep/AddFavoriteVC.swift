//
//  AddFavoriteVC.swift
//  Keep
//
//  Created by Mirim An on 1/30/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class AddFavoriteVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        nameField.autocapitalizationType = .words
        nameField.placeholder = "Name is required"
        hideKeyboard()
    
    }
   
    @IBAction func dismissView(_ sender: Any) {
        
        nameField.endEditing(true)
        dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let name = nameField.text, name != "" else { return }
        let favorite = FavoritedItem(name: name.capitalized)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(favorite)
            
                print("Favorite item \(favorite.name) has been added")
            
        }
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: REFRESH_FAVORITES, object: nil)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        return true
    }
}
