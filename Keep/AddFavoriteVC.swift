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
    @IBOutlet weak var saveButton: CustomButton!
    
    let store = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.becomeFirstResponder()
        nameField.delegate = self
        nameField.textAlignment = .center
        nameField.autocapitalizationType = .words
        nameField.addTarget(self, action: #selector(checkTextField(sender:)), for: .editingChanged)
        saveButton.backgroundColor = .red
        setupViews()
    }
    
    @IBAction func dismissView(_ sender: Any) {
  }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        save()
    }
    
    @IBAction func cancel(_ sender: Any) {
        nameField.endEditing(true)
        nameField.resignFirstResponder()
        dismiss(animated: false, completion: nil)
    }
    
    func save() {
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
    
    func setupViews(){
        view.backgroundColor = Colors.dawn
    }
    
    func checkTextField(sender: UITextField) {
        var textLength = 0
        if let text = sender.text {
            textLength = text.trimmingCharacters(in: .whitespacesAndNewlines).characters.count
        }
        if textLength > 0 {
            saveButton.isEnabled = true
            saveButton.backgroundColor = Colors.tealish
            
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .red
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        save()
        return true
    }
}
