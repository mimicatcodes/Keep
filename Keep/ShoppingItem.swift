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
    
    convenience init(name: String) {
        
        self.init()
        self.name = name
        
    }
}
