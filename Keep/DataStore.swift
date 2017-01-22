//
//  DataStore.swift
//  Keep
//
//  Created by Luna An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.

import Foundation
import RealmSwift

class DataStore{

    static let sharedInstance = DataStore()
    fileprivate init(){}
    
    var allItems = try! Realm().objects(Item.self)
    var fridgeItems = try! Realm().objects(Item.self).filter("location == 'Fridge'")
    var freezerItems = try! Realm().objects(Item.self).filter("location == 'Freezer'")
    var pantryItems = try! Realm().objects(Item.self).filter("location == 'Pantry'")
    var otherItems = try! Realm().objects(Item.self).filter("location == 'Other'")
    
    var fridgeSectionNames: [String] {
        
        return Set(fridgeItems.value(forKeyPath: "category") as! [String]).sorted()
    }

    var freezerSectionNames: [String] {
        return Set(freezerItems.value(forKeyPath: "category") as! [String]).sorted()
    }
    
    var pantrySectionNames: [String] {
        return Set(pantryItems.value(forKeyPath: "category") as! [String]).sorted()
    }
    
    var otherSectionNames: [String] {
        return Set(otherItems.value(forKeyPath: "category") as! [String]).sorted()
    }
    
    var buttonStatus = ""
    
}
