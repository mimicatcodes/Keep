//
//  ForgotPasswordViewController.swift
//  Keep
//
//  Created by Mirim An on 12/22/16.
//  Copyright © 2016 Mimicatcodes. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBAction func AlreadyHaveAccountButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
