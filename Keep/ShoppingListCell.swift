//
//  ShoppingListCell.swift
//  Keep
//
//  Created by Luna An on 2/20/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ShoppingListCell: MGSwipeTableCell {
    
    @IBOutlet weak var numOfItemsView: UIView!
    @IBOutlet weak var shoppingListTitleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var numOfItemsRemainingLabel: UILabel!
    
    @IBOutlet weak var itemsLabel: UILabel!
}


