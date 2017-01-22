//
//  StockItem.swift
//  Keep
//
//  Created by Luna An on 1/19/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation
import RealmSwift


class Item : Object {
    
    dynamic var name: String = ""
    dynamic var quantity : String = "1"
    dynamic var expDate: String = "" 
    dynamic var purchaseDate: String = ""
    dynamic var isConsumed: Bool = false
    dynamic var location: String = ""
    dynamic var category: String = ""
    
    convenience init(name: String, quantity: String, expDate: String, purchaseDate: String, isConsumed: Bool, location: String, category: String) {
        self.init()
        self.name = name
        self.quantity = quantity
        self.expDate = expDate
        self.purchaseDate = purchaseDate
        self.isConsumed = isConsumed
        self.location = location
        self.category = category
    }
    
}
