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
    
    var allShopingLists = try! Realm().objects(ShoppingList.self)

     /*
     let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())
     
     let nextWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())
     
     let thisWeek = Calendar.current.date(byAdding: .weekOfYear, value: 0, to: Date())

     let fallsBetween = (startDate...endDate).contains(Date())

 */
    var tappedSLItemToSendToLocation = ""
    var listID = ""

    var allFavoritedItems = try! Realm().objects(FavoritedItem.self).sorted(byProperty: "name", ascending: true)
    var allShoppingItems = try! Realm().objects(ShoppingItem.self)
    
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
    
    var buttonStatus = "Fridge"
    
}
