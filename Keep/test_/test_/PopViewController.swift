//
//  PopViewController.swift
//  test_
//
//  Created by Mirim An on 1/21/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

class PopViewController: UIViewController {

    var popup:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func didPressButton(_ sender: Any) {
        showAlert()
    }
    
    func showAlert() {
        // customise your view
        popup = UIView(frame: CGRect(x: 100, y: 200, width: 200, height: 200))
        popup.backgroundColor = UIColor.red
        
        self.view.addSubview(popup)
        
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.dismissAlert), userInfo: nil, repeats: false)
    }
    
    func dismissAlert(){
        if popup != nil { // Dismiss the view from here
            popup.removeFromSuperview()
        }
    }
}
