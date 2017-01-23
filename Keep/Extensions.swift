//
//  Extensions.swift
//  Keep
//
//  Created by Luna An on 1/22/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation
import UIKit

// Hide keyboard 
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
