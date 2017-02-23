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
    dynamic var uniqueID: String = ""
    dynamic var quantity : String = "1"
    dynamic var exp = Date()
    dynamic var purchaseDate = Date()
    dynamic var isExpired: Bool = false
    dynamic var isExpiring: Bool = false
    dynamic var isFavorited: Bool = false
    dynamic var location: String = ""
    dynamic var category: String = ""
    
    convenience init(name: String, uniqueID: String, quantity: String, exp: Date, purchaseDate: Date, location: String, category: String) {
        self.init()
        self.name = name
        self.uniqueID = uniqueID
        self.quantity = quantity
        self.exp = exp
        self.purchaseDate = purchaseDate
        self.location = location
        self.category = category
    }
    
  }
    

