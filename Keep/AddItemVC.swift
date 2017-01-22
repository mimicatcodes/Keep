//
//  AddItemVC.swift
//  Keep
//
//  Created by Luna An on 1/6/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class AddItemVC: UIViewController {

    @IBOutlet weak var createItemView: UIView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        
    }
    
    
    func setupViews(){
        view.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.35)
        createItemView.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.00)
    }
    
    
}
