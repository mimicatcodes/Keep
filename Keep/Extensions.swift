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

extension UITextField {

    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = Colors.mainBorder.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIView {
    
    func underlinedBorder(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.backgroundColor = Colors.mainBorder.cgColor
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.layer.shadowOffset = .zero
    }
    
    func removeBorder(){
        let border = CALayer()
        let width = CGFloat(0.0)
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.backgroundColor = Colors.mainBorder.cgColor
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.layer.shadowOffset = .zero
    }
    
    
    func rightBorder(){
        let border = CALayer()
        border.frame = CGRect(x: self.frame.size.width - 1, y: 0, width: 1, height: self.frame.size.height)
        border.backgroundColor = Colors.mainBorder.cgColor
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.layer.shadowOffset = .zero
    }
    
}

// For rotation

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    var radiansToDegrees: Double { return Double(self) * 180 / .pi }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}


