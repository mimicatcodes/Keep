//
//  Constants.swift
//  Keep
//
//  Created by Luna An on 12/22/16.
//  Copyright © 2016 Mimicatcodes. All rights reserved.
//

import Foundation
import UIKit
import NotificationCenter

struct Colors {
    static let main = UIColor(red: 133/255.0, green: 219/255.0, blue: 205/255.0, alpha: 1)
    static let mainBg = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
    static let button = UIColor(red: 113/255.0, green: 113/255.0, blue: 113/255.0, alpha: 1)
    static let mainBorder = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
    static let border = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1)
    static let seperator = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1)
    static let seperatorTwo = UIColor(red:219/255.0, green:219/255.0, blue:219/255.0, alpha: 1.0)
    static let favorite = UIColor(red: 255/255.0, green: 137/255.0, blue: 137/255.0, alpha: 1)
    static let warning = UIColor(red: 237/255.0, green: 93/255.0, blue: 93/255.0, alpha: 1)
    static let added = UIColor(red: 35/255.0, green: 213/255.0, blue: 185/255.0, alpha: 1)
    static let dawn = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.10)
}

struct NotificationName {
    static let refreshTableview = NSNotification.Name("RefeshTVNotification")
    static let refreshItemList = NSNotification.Name("RefreshItemListNotification")
    //static let refreshExpList = NSNotification.Name("RefreshExpiredItems")
    static let refreshFavorites = NSNotification.Name("RefreshFavorites")
    static let refreshScannedItems = NSNotification.Name("RefreshScannedItems")
}

struct Identifiers {
    struct Cell {
        static let stockCell = "stockCell"
        static let shoppingListCell = "shoppingListCell"
        static let listDetailCell = "listDetailCell"
        static let accountCell = "accountCell"
        static let scannedItemCell = "scannedItemCell"
    }
    struct Segue {
        //static let toNavForScannedItems = "toNavForScannedItems"
        static let toScannedItems = "toScannedItems"
        static let addScannedItem = "addScannedItem"
        static let addList = "addList"
        static let showItems = "showItems"
        static let addItemToSL = "addItemToSL"
    }
}

struct Locations {
    static let fridge = Location.Fridge.rawValue
    static let freezer = Location.Freezer.rawValue
    static let pantry = Location.Pantry.rawValue
    static let other = Location.Other.rawValue
}

struct Fonts {
    static let montserratRegular = "Montserrat-Regular"
    static let latoRegular = "Lato-Regular"
    static let latoSemibold = "Lato-Semibold"
}

struct TesseractLang {
    static let english = "eng"
}

struct Filters {
    static let category = "category == %@"
    static let uniqueID = "uniqueID contains[c] %@"
}

