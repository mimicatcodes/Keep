//
//  Favorites.swift
//  Keep
//
//  Created by Luna An on 1/30/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation
import RealmSwift

class FavoritedItem : Object {
    
    dynamic var name: String = ""

    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
}

