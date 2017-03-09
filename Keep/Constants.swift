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
    static let duckEggBlue = UIColor.rgb(229, 253, 249, 1)
    static let lightTeal = UIColor.rgb(133, 219, 205, 1)
    static let lightTealTwo = UIColor.rgb(178, 231, 222, 1)
    static let lightTealThree = UIColor.rgb(135, 219, 206, 1)

    static let tealish =  UIColor.rgb(35, 213, 185, 1)
    static let tealishFaded = UIColor.rgb(35, 213, 185, 0.3)
    
    static let whiteTwo = UIColor.rgb(245, 245, 245, 1)
    static let whiteThree = UIColor.rgb(219, 219, 219, 1)
    static let whiteFour = UIColor.rgb(229, 229, 229, 1)
    static let whiteFive = UIColor.rgb(213, 213, 213, 1)
    static let whiteSix = UIColor.rgb(242, 242, 242, 1)

    static let warmGrey = UIColor.rgb(131, 131, 131, 1)
    static let warmGreyTwo = UIColor.rgb(146, 146, 146, 1)
    static let warmGreyThree = UIColor.rgb(113, 113, 113, 1)
    static let warmGreyFour = UIColor.rgb(123, 123, 123, 1)
    static let warmGreyFive = UIColor.rgb(151, 151, 151, 1)

    static let greyishBrown = UIColor.rgb(77, 77, 77, 1)
    static let brownishGrey = UIColor.rgb(96, 96, 96, 1)
    static let brownishGreyTwo = UIColor.rgb(100, 100, 100, 1)
    static let brownishGreyThree = UIColor.rgb(94, 94, 94, 1)
    
    static let pastelRed = UIColor.rgb(237, 93, 93, 1)
    static let salmon = UIColor.rgb(249, 117, 102, 1)
    static let peachyPink = UIColor.rgb(255, 137, 137, 1)

    static let pinkishGrey = UIColor.rgb(202, 202, 202, 1)
    static let pinkishGreyTwo = UIColor.rgb(201, 201, 201, 1)
    
    static let dawn = UIColor.rgb(0, 0, 0, 0.10)
    }

struct Keys {
    static let searchField = "searchField"
    static let placeholderLabel = "placeholderLabel"
    static let name = "name"
    static let category = "category"
    static let title = "title"
    
    struct UserDefaults {
        static let hour = "hour"
        static let minute = "minute"
        static let onboardingComplete = "onboardingComplete"
    }
}

struct NotificationName {
    static let refreshTableview = NSNotification.Name("RefeshTVNotification")
    static let refreshItemList = NSNotification.Name("RefreshItemListNotification")
    //static let refreshExpList = NSNotification.Name("RefreshExpiredItems")
    static let refreshFavorites = NSNotification.Name("RefreshFavorites")
    static let refreshScannedItems = NSNotification.Name("RefreshScannedItems")
    static let refreshMainTV = NSNotification.Name("RefreshMainTV")
    static let refreshCharts = NSNotification.Name("RefreshCharts")
}

struct Identifiers {
    struct Cell {
        static let stockCell = "stockCell"
        static let shoppingListCell = "shoppingListCell"
        static let listDetailCell = "listDetailCell"
        static let accountCell = "accountCell"
        static let scannedItemCell = "scannedItemCell"
        static let searchCell = "searchCell"
        static let favoriteCell = "favoriteCell"
        static let nameCell = "nameCell"
    }
    struct Segue {
        static let toScannedItems = "toScannedItems"
        static let addScannedItem = "addScannedItem"
        static let addList = "addList"
        static let showItems = "showItems"
        static let addItemToSL = "addItemToSL"
        static let editIems = "editItems"
        static let unwindToMain = "unwindToMain"
        static let favToStock = "favToStock"
        static let moveToStock = "moveListItemToStock"
        static let setReminder = "setReminder"
    }
    
    struct Storyboard {
        static let main = "Main"
        static let onboarding = "Onboarding"
        static let mainApp = "MainApp"
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
    static let listUniqueID = "list.uniqueID contains[c] %@"
    static let name = "name contains[c] %@"
    //static let isExpiringInAWeek = "isExpiringInAWeek == true"
    static let isExpiring = "isExpiring == true AND isExpired == false"
    static let isExpiringToday = "isExpiringToday == true AND isExpired == false"
    static let isExpired = "isExpired == true"
    static let fridge = "location == 'Fridge'"
    static let freezer = "location == 'Freezer'"
    static let pantry = "location == 'Pantry'"
    static let other = "location == 'Other'"
    
    static let vegetables = "category == 'Vegetables'"
    
    static let fruits = "category == 'Fruits'"
    
    static let grainsPasta = "category CONTAINS[c] 'Pastas'"
    static let grainsOther = "category CONTAINS[c] 'Grains'"
    
    static let proteinMeats = "category CONTAINS[c] 'Meats'"
    static let proteinBeans = "category CONTAINS[c] 'Beans'"
    static let proteinNuts = "category CONTAINS[c] 'Nuts'"
    
    static let dairy = "category == 'Dairy'"
}

struct EmptyString {
    static let none = ""
}

struct Labels {
    static let done = "Done"
    static let cancel = "Cancel"
    static let expired = "Expired!"
    static let expiring = "Expiring soon"
    static let expiringToday = "Expiring today"
    static let dayLeft = " day left"
    static let daysLeft = " days left"
    static let addedOn = "Added on "
    static let purchasedOn = "Purchased on "
    static let itemEdited = "Item edited"
    static let itemAdded = "Item added"
    
    static let singular = "item in stock"
    static let plural = "items in stock"
    static let signularExpiring = "item is expiring"
    static let pluralExpiring = "items are expiring"
    
    static let itemIs = "Item is"
    static let ItemsAre = "Items are"
}

struct OnBoarding {
    static let checkListTitle = "Stay Organized"
    static let checkListBody =
    "Manage your foods easily. \r\nAdd and move items to your kitchen,\r\ncheck expiration dates easily, and make a shopping list to shop more efficiently!"
    static let piggyBankTitle = "Save Money"
    static let piggyBankBody = "Reduce your food waste, and\r\nknow when your foods are about to expire."
    static let produceTitle = "Be Healthy"
    static let produceBody = "Know your shopping trends, and\r\nlearn to buy healthier items."
}

struct LocalNotification {
    static let title = "Spoiler Alert!"
    static let subtitleSingular = " item is expiring today"
    static let subtitlePlural = " items are expiring today"
    static let bodySingular = "Use it today before it goes bad!"
    static let bodyPlular = "Make sure to use them today!"
    static let categoryIdentifier = "reminder"
    static let messageforNoNeed = "no notification needed - no expiring items today"
}

struct DateFormat {
    static let monthDayYear = "MMM dd, yyyy"
}
struct FoodGroups {
    static let categories = [FiveFoodGroups.Vegetables.rawValue, FiveFoodGroups.Fruits.rawValue, FiveFoodGroups.Grains.rawValue, FiveFoodGroups.Dairy.rawValue, FiveFoodGroups.Protein.rawValue]
    static let groceryCategories:[FoodCategories] = [.other, .vegetables, .fruits, .pastasAndNoodles, .otherGrains, .dairy, .meatsSeafoodsAndEggs, .condimentsAndSauce, .beansPeasAndTofu, .nutsAndSeeds, .beverages, .alcoholicBeverages, .healthAndPersonalCare, .householdAndCleaning ]
}

struct FoodItems {
    static let all  = [vegetables, fruits, pastaAndNoodles, otherGrains, dairy, meatsSeafoodsAndEggs, beansPeasAndTofu, nutsAndSeeds, beverages, alcoholicBeverages, condimentsAndSauce, healthAndPersonalCare, householdAndCleaning]
}

struct SearchPlaceholder {
    static let search =  "Search                                                            "
}

struct ImageName {
    static let clear = "Clear"
    static let delete1 = "Delete1"
    static let delete2 = "Delete2"
    static let editGrey1 = "EditGrey1"
    static let editGrey2 = "EditGrey2"
}

enum FiveFoodGroups: String {
    case Protein
    case Dairy
    case Vegetables
    case Fruits
    case Grains
}

enum Location : String {
    case Fridge, Freezer, Pantry, Other
}


enum SettingMenu : String {
    case reminder = "Set Time for Reminder"
    case sendFeedback = "Send Feedback"
}

extension UIImage {
    enum Asset: String {
        case checkList = "checkList"
        case piggyBank = "piggyBank"
        case produce = "produce"
        
        var image: UIImage {
            return UIImage(asset: self)
        }
    }
    
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}

