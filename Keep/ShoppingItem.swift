//
//  ShoppingItem.swift
//  Keep
//
//  Created by Luna An on 1/19/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation
import RealmSwift

class ShoppingItem: Object {
    
    dynamic var name:String = ""
    dynamic var isPurchased:Bool = false
    dynamic var list: ShoppingList? // to-one
    
    convenience init(name: String) {
        
        self.init()
        self.name = name
        
    }
}

class ShoppingList: Object {
    
    dynamic var title: String = ""
    dynamic var isCreatedAt: String = ""
    dynamic var numOfItems: Int = 0
    let shoppingItems = List<ShoppingItem>() // to-many
    
    convenience init(title: String, isCreatedAt: String) {
        
        self.init()
        self.title = title
        self.isCreatedAt = isCreatedAt
        
    }
    
}
