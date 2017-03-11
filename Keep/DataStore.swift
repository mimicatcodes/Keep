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
    
    var allItems = try! Realm().objects(Item.self).sorted(byProperty: Keys.exp, ascending: true)
    var fridgeItems = try! Realm().objects(Item.self).filter(Filters.fridge).sorted(byProperty: Keys.exp, ascending: true)
    var freezerItems = try! Realm().objects(Item.self).filter(Filters.freezer).sorted(byProperty: Keys.exp, ascending: true)
    var pantryItems = try! Realm().objects(Item.self).filter(Filters.pantry).sorted(byProperty: Keys.exp, ascending: true)
    var otherItems = try! Realm().objects(Item.self).filter(Filters.other).sorted(byProperty: Keys.exp, ascending: true)

    var allShopingLists = try! Realm().objects(ShoppingList.self).sorted(byProperty: Keys.title, ascending: true)
    
    var scannedItemToAdd = EmptyString.none
    var scannedItemIndex:Int?

    var listToEdit:ShoppingList?
    var tappedSLItemToSendToLocation = EmptyString.none
    var listID = EmptyString.none

    var allFavoritedItems = try! Realm().objects(FavoritedItem.self).sorted(byProperty: Keys.name, ascending: true)
    var allShoppingItems = try! Realm().objects(ShoppingItem.self).sorted(byProperty: Keys.name, ascending: true)
        
    var fridgeSectionNames: [String] {
        return Set(fridgeItems.value(forKeyPath: Keys.category) as! [String]).sorted()
    }

    var freezerSectionNames: [String] {
        return Set(freezerItems.value(forKeyPath: Keys.category) as! [String]).sorted()
    }
    
    var pantrySectionNames: [String] {
        return Set(pantryItems.value(forKeyPath: Keys.category) as! [String]).sorted()
    }
    
    var otherSectionNames: [String] {
        return Set(otherItems.value(forKeyPath: Keys.category) as! [String]).sorted()
    }
    
    var buttonStatus = Locations.fridge
    var settingExpire = EmptyString.none
}
