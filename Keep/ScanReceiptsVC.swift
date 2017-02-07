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
    
    var resultsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print("9999999999 + \(resultsArray)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return resultsArray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scannedItemCell", for: indexPath) as! scannedItemCell
        
        cell.titleLabel.text = resultsArray[indexPath.row]
            print("AUHHHHHHH")
        
        cell.selectionStyle = .none
        
        // buttons
        cell.editAddButton.tag = indexPath.row
        cell.editAddButton.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)
       
        return cell
    }
    
    func deleteRow(){
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            
            resultsArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

class scannedItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
   
    @IBOutlet weak var editAddButton: UIButton!

}

