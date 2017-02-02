//
//  MoveTo.swift
//  Keep
//
//  Created by Luna An on 2/1/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation
import UIKit
import NotificationCenter
import RealmSwift

class MoveTo: UIView {
    
    let store = DataStore.sharedInstance
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        
        if store.tappedSLItemToSendToLocation != "" {
            
            let name = store.tappedSLItemToSendToLocation
            let selectedIndex = sender.tag
            let realm = try! Realm()
            try! realm.write {
                
                switch selectedIndex {
                case 0:
                    
                    let item = Item(name: name, quantity: "1", exp: Date(), purchaseDate: Date(), isConsumed: false, location: "Fridge", category: "Uncategorized")
                    realm.add(item)
                    print("Fridge for item \(store.tappedSLItemToSendToLocation) tapped")
                case 1:
                    let item = Item(name: name, quantity: "1", exp: Date(), purchaseDate: Date(), isConsumed: false, location: "Freezer", category: "Uncategorized")
                    realm.add(item)
                    print("Freezer for item \(store.tappedSLItemToSendToLocation) tapped")
                case 2:
                    let item = Item(name: name, quantity: "1", exp: Date(), purchaseDate: Date(), isConsumed: false, location: "Pantry", category: "Uncategorized")
                    realm.add(item)
                    print("Pantry for item \(store.tappedSLItemToSendToLocation) tapped")
                case 3:
                    let item = Item(name: name, quantity: "1", exp: Date(), purchaseDate: Date(), isConsumed: false, location: "Other", category: "Uncategorized")
                    realm.add(item)
                    print("Other for item \(store.tappedSLItemToSendToLocation) tapped")
                default:
                    break
                }
            }
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("MoveTo", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        DispatchQueue.main.async {
            self.itemTitleLabel.text = "Add \(self.store.tappedSLItemToSendToLocation) to"

        }
        
        }
    }

