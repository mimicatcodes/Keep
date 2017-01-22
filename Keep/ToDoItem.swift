//
//  ToDoItem.swift
//  Keep
//
//  Created by Mirim An on 1/6/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class ToDoItem: NSObject {
    // A text description of this item.
    var title: String
    
    // A Boolean value that determines the completed state of this item.
    var isCompleted: Bool
    
    // Returns a ToDoItem initialized with the given text and default completed value.
    init(title: String) {
        self.title = title
        self.isCompleted = false
    }

}
