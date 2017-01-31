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
    
    static let emerald = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
}

let MAIN_COLOR = UIColor(red: 133/255.0, green: 219/255.0, blue: 205/255.0, alpha: 1)
let MAIN_BG_COLOR = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
let MAIN_BUTTON_LABEL_GRAY = UIColor(red: 113/255.0, green: 113/255.0, blue: 113/255.0, alpha: 1)
let MAIN_BORDER_COLOR = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
let SEPERATOR_COLOR_DEFAULT = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1)
let FAV_COLOR = UIColor(red: 255/255.0, green: 137/255.0, blue: 137/255.0, alpha: 1)
let EXPIRING_WARNING_COLOR = UIColor(red: 237/255.0, green: 93/255.0, blue: 93/255.0, alpha: 1)
let ADDED_LABEL_COLOR = UIColor(red: 35/255.0, green: 213/255.0, blue: 185/255.0, alpha: 1)



// NOTIFICATIONS
let REFRESH_TV_NOTIFICATION = NSNotification.Name("RefeshTVNotification")
let REFRESH_ITEM_LIST_NOTIFICATION = NSNotification.Name("RefreshItemListNotification")

let REFRESH_FAVORITES = NSNotification.Name("RefreshFavorites")
