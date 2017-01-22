//
//  ViewController.swift
//  test_
//
//  Created by Mirim An on 1/20/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var baseMessage: String?
    var remainingTime: Double = 0
    var alertController: UIAlertController?
    var alertTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    @IBAction func didPressButton(_ sender: Any) {
         showAlertMsg("Hello", message: "Added", time: 0.2)
    }
    
  
    func showAlertMsg(_ title: String, message: String, time: Double) {
        
        guard (self.alertController == nil) else {
            print("Alert already displayed")
            return
        }
        
        self.baseMessage = message
        self.remainingTime = time
        
        self.alertController = UIAlertController(title: title, message: self.baseMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Alert was cancelled")
            self.alertController = nil;
            self.alertTimer?.invalidate()
            self.alertTimer = nil
        }
        
        self.alertController?.addAction(cancelAction)
        
        self.alertTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
        
        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    func countDown() {
        
        self.remainingTime -= 1
        if (self.remainingTime < 0) {
            self.alertTimer?.invalidate()
            self.alertTimer = nil
            self.alertController!.dismiss(animated: true, completion: {
                self.alertController = nil
            })
        } else {
            self.alertController!.message = self.alertMessage()
        }
        
    }
    
    func alertMessage() -> String {
        var message=""
        if let baseMessage=self.baseMessage {
            message=baseMessage+" "
        }
        return(message+"\(self.remainingTime)")
    }
}


