//
//  Extensions.swift
//  Keep
//
//  Created by Luna An on 1/22/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

// make rgb handling extension


extension UITextField {

    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = MAIN_BORDER_COLOR.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIView {
    
    func underlinedBorder(){
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.bounds.size.height - 1, width: UIScreen.main.bounds.width, height: 1)
        border.backgroundColor = MAIN_BORDER_COLOR.cgColor
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.layer.shadowOffset = .zero
    }
    
}
