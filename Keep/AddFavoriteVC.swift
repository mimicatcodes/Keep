//
//  AddFavoriteVC.swift
//  Keep
//
//  Created by Luna An on 1/30/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class AddFavoriteVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    
    let store = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.becomeFirstResponder()
        nameField.autocapitalizationType = .words
        hideKeyboard()
        setupViews()
    }
    
    @IBAction func dismissView(_ sender: Any) {
        nameField.endEditing(true)
        nameField.resignFirstResponder()
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveFavItem()
    }
    
    @IBAction func cancel(_ sender: Any) {
        nameField.endEditing(true)
        nameField.resignFirstResponder()
        dismiss(animated: false, completion: nil)
    }
    
    func saveFavItem(){
        guard let name = nameField.text, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let favorite = FavoritedItem(name: name.capitalized)
        let realm = try! Realm()
        try! realm.write {
            realm.add(favorite)
        }
        NotificationCenter.default.post(name: NotificationName.refreshFavorites, object: nil)
        dismiss()
    }
    
    func dismiss() {
        nameField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.endEditing(true)
        nameField.resignFirstResponder()
        saveFavItem()
        return true
    }
    
    func setupViews(){
        view.backgroundColor = Colors.dawn
    }
}
