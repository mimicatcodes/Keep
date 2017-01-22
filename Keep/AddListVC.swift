//
//  AddListVC.swift
//  Keep
//
//  Created by Mirim An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class AddListVC: UIViewController, UITextViewDelegate, UIPickerViewDelegate {
    
    @IBOutlet weak var createListView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismissViewController()
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismissViewController()
    }
    func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupViews(){
        view.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.35)
        createListView.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.00)
    }


}
