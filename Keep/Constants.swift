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
    static let lightTeal = UIColor(red: 133/255.0, green: 219/255.0, blue: 205/255.0, alpha: 1)
    static let lightTealTwo = UIColor(red: 178/255.0, green: 231/255.0, blue: 222/255.0, alpha: 1)
    static let lightTealThree = UIColor(red: 135/255.0, green: 219/255.0, blue: 206/255.0, alpha: 1)

    static let tealish =  UIColor(red: 35/255.0, green: 213/255.0, blue: 185/255.0, alpha: 1)
    static let tealishFaded = UIColor(red: 35/255.0, green: 213/255.0, blue: 185/255.0, alpha: 0.3)
    
    static let whiteTwo = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
    static let whiteThree = UIColor(red:219/255.0, green:219/255.0, blue:219/255.0, alpha: 1.0)
    static let whiteFour = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
    static let whiteFive = UIColor(red: 213/255.0, green: 213/255.0, blue: 213/255.0, alpha: 1)
    static let whiteSix = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)

    static let warmGrey = UIColor(red: 131/255.0, green: 131/255.0, blue: 131/255.0, alpha: 1)
    static let warmGreyTwo = UIColor(red: 146/255.0, green: 146/255.0, blue: 146/255.0, alpha: 1)
    static let warmGreyThree = UIColor(red: 113/255.0, green: 113/255.0, blue: 113/255.0, alpha: 1)
    static let warmGreyFour = UIColor(red: 123/255.0, green: 123/255.0, blue: 123/255.0, alpha: 1)
    static let warmGreyFive = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1)

    static let greyishBrown = UIColor(red: 77/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1)
    static let brownishGrey = UIColor(red: 96/255.0, green: 96/255.0, blue: 96/255.0, alpha: 1)
    static let brownishGreyTwo = UIColor(red:100/255.0, green:100/255.0, blue:100/255.0, alpha: 1.0)
    
    static let pastelRed = UIColor(red: 237/255.0, green: 93/255.0, blue: 93/255.0, alpha: 1)
    static let salmon = UIColor(red: 249/255.0, green: 117/255.0, blue: 102/255.0, alpha: 1)
    static let peachyPink = UIColor(red: 255/255.0, green: 137/255.0, blue: 137/255.0, alpha: 1)

    static let pinkishGrey = UIColor(red: 202/255.0, green: 202/255.0, blue: 202/255.0, alpha: 1)
    static let pinkishGreyTwo = UIColor(red: 201/255.0, green: 201/255.0, blue: 201/255.0, alpha: 1)
    
    static let dawn = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.10)
    
    static let dodgerBlue = UIColor(red: 76/255.0, green: 169/255.0, blue: 247/255.0, alpha: 1)
}

struct Keys {
    static let searchField = "searchField"
    static let placeholderLabel = "placeholderLabel"
}

struct NotificationName {
    static let refreshTableview = NSNotification.Name("RefeshTVNotification")
    static let refreshItemList = NSNotification.Name("RefreshItemListNotification")
    //static let refreshExpList = NSNotification.Name("RefreshExpiredItems")
    static let refreshFavorites = NSNotification.Name("RefreshFavorites")
    static let refreshScannedItems = NSNotification.Name("RefreshScannedItems")
    static let refreshMainTV = NSNotification.Name("RefreshMainTV")
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
        static let editIems = "editItems"
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
    static let montserratSemiBold = "Montserrat-SemiBold"
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

