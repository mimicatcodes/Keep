//
//  MoveToVC.swift
//  Keep
//
//  Created by Luna An on 2/1/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class MoveToVC: UIViewController {
    
    // TODO: name duplicates! - fix

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    
    let store = DataStore.sharedInstance
    var locations:[String] = [Locations.fridge, Locations.freezer, Locations.pantry, Locations.other]
    var location:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        saveButton.setTitleColor(Colors.tealish, for: .normal)
        saveButton.backgroundColor = Colors.whiteTwo
        view.backgroundColor = Colors.dawn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if store.tappedSLItemToSendToLocation != "" {
            if let location = location {
                let name = store.tappedSLItemToSendToLocation
                let uuid = UUID().uuidString
        
                let realm = try! Realm()
                try! realm.write {
                    let item = Item(name: name, uniqueID: uuid, quantity: "1", exp: Date(), purchaseDate: Date(), location: location, category: "Uncategorized")
                    realm.add(item)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func locationBtnsTapped(_ sender: UIButton) {
        
        for (i,button) in buttons.enumerated() {
            if i == sender.tag {
                location = locations[i]
                print("selected location is:\(location)")
                print("Selected sender.tag value is --------\(sender.tag)")
                button.isSelected = true
                button.setTitleColor(Colors.tealish, for: .selected)
                print("is button selected? \(button.isSelected)")
            } else {
                print("NOT selected sender.tag value is --------\(i)")
                button.isSelected = false
                button.setTitleColor(Colors.warmGreyThree, for: .normal)
            }
        }
        saveButton.isEnabled = true
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = Colors.tealish
    }

    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupViews(){
        if store.tappedSLItemToSendToLocation != "" {
            DispatchQueue.main.async {
                self.itemTitleLabel.text = "Add \(self.store.tappedSLItemToSendToLocation) to"
            }
        } else {
            print("Not possible")
        }
    }
}
