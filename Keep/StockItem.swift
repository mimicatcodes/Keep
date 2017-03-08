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
    
    dynamic var name: String = EmptyString.none
    dynamic var uniqueID: String = EmptyString.none
    dynamic var quantity : String = "1"
    dynamic var exp = Date()
    dynamic var addedDate = Date()
    dynamic var isExpired: Bool = false
    dynamic var isExpiring: Bool = false
    dynamic var isExpiringInAWeek: Bool = false
    dynamic var isFavorited: Bool = false
    dynamic var location: String = EmptyString.none
    dynamic var category: String = EmptyString.none
    
    convenience init(name: String, uniqueID: String, quantity: String, exp: Date, addedDate: Date, location: String, category: String) {
        self.init()
        self.name = name
        self.uniqueID = uniqueID
        self.quantity = quantity
        self.exp = exp
        self.addedDate = addedDate
        self.location = location
        self.category = category
    }
}


