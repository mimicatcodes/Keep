//
//  ScanReceiptsVC.swift
//  Keep
//
//  Created by Luna An on 2/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

class ScanReceiptsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var resultsArray:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print("9999999999 + \(resultsArray)")
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = resultsArray {
            return results.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scannedItemCell", for: indexPath) as! scannedItemCell
        if let results = resultsArray {
             cell.titleField.text = results[indexPath.row]
            print("AUHHHHHHH")
        }
        cell.selectionStyle = .none
       
        return cell
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

class scannedItemCell: UITableViewCell {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
}

