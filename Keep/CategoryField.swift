//
//  CategoryField.swift
//  Keep
//
//  Created by Luna An on 2/23/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

class CategoryField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:))  || action == #selector(delete(_:)){
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
