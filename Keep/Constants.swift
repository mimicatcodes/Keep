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
let FAV_COLOR = UIColor(red: 255/255.0, green: 137/255.0, blue: 137/255.0, alpha: 1)
let REFRESH_TV_NOTIFICATION = NSNotification.Name("RefeshTVNotification")
let REFRESH_ITEM_LIST_NOTIFICATION = NSNotification.Name("RefreshItemListNotification")
