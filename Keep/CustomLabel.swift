//
//  CustomLabel.swift
//  Keep
//
//  Created by Luna An on 2/27/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)))
    }
}
