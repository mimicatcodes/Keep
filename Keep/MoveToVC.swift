//
//  MoveToVC.swift
//  Keep
//
//  Created by Mirim An on 2/1/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class MoveToVC: UIViewController {
    
    let store = DataStore.sharedInstance
    
    var location:String?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet var buttons: [UIButton]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.35)
        topView.layer.cornerRadius = 8
        topView.backgroundColor = UIColor.white
        saveButton.layer.cornerRadius = 5
        saveButton.backgroundColor = UIColor.white
        cancelButton.layer.cornerRadius = 5
        cancelButton.backgroundColor = UIColor.white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
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
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if store.tappedSLItemToSendToLocation != "" {
            if let location = location {
                let name = store.tappedSLItemToSendToLocation
                
                let realm = try! Realm()
                try! realm.write {
                    let item = Item(name: name, quantity: "1", exp: Date(), purchaseDate: Date(), isConsumed: false, location: location, category: "Uncategorized")
                    
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
        
        let selectedIndex = sender.tag
        
                switch selectedIndex {
                case 0:
                    
                    location = "Fridge"
                    print("Fridge btn tapped")
                    print("\(buttons[0].isSelected)")
                case 1:
                    
                    location = "Freezer"
                    print("Freezer btn tapped")
                case 2:
                    
                    location = "Pantry"
                    print("Pantry btn tapped")
                case 3:
                    
                    location = "Other"
                    print("Other btn tapped")
                default:
                    break

        }
        
        for (index, button) in buttons.enumerated() {
            if index == selectedIndex {
                button.isSelected = true
                button.setTitleColor(MAIN_COLOR, for: .selected)
                                
            } else {
                button.isSelected = false
                button.setTitleColor(MAIN_BUTTON_LABEL_GRAY, for: .normal)

            }
        }
        
    }

    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
