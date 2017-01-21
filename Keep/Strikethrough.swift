//
//  Strikethrough.swift
//  Keep
//
//  Created by Luna An on 1/6/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class StrikeThroughText: UILabel {

    let strikeThroughLayer: CALayer
    
    var strikeThrough : Bool {
        didSet {
            strikeThroughLayer.isHidden = !strikeThrough
            if strikeThrough {
                resizeStrikeThrough()
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        strikeThroughLayer = CALayer()
        strikeThroughLayer.backgroundColor = UIColor.red.cgColor
        strikeThroughLayer.isHidden = true
        strikeThrough = false
        
        super.init(frame: frame)
        layer.addSublayer(strikeThroughLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeStrikeThrough()
    }
    
    let kStrikeOutThickness: CGFloat = 2.0
    
    
    func resizeStrikeThrough() {
        if let text = text {
            let textSize = text.size(attributes: [NSFontAttributeName:font])
     
            strikeThroughLayer.frame = CGRect(x: 0, y: bounds.size.height/2,
                                              width: textSize.width, height: kStrikeOutThickness)
        }
    }
}
