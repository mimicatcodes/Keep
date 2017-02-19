//
//  CustomButton.swift
//  Keep
//
//  Created by Luna An on 2/17/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}


@IBDesignable class CustomView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: CGColor = Colors.tealish.cgColor {
        didSet {
            layer.borderColor = borderColor
        }
    }
}

@IBDesignable class CustomTextField: UITextField {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            layer.borderColor = Colors.tealish.cgColor
        }
    }
}

