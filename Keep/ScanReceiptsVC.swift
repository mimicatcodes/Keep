//
//  ScanReceiptsVC.swift
//  Keep
//
//  Created by Luna An on 2/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

class ScanReceiptsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let store = DataStore.sharedInstance
    @IBOutlet weak var tableView: UITableView!
    
    var resultsArray = [String]()
    var titleString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        NotificationCenter.default.addObserver(forName: REFRESH_SCANNED_ITEMS, object: nil, queue: nil) { notification in
            print("notification is \(notification)")
            self.resultsArray.remove(at: self.store.scannedItemIndex!)
            self.tableView.reloadData()
        }
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
            print(resultsArray[indexPath.row])
        
        cell.selectionStyle = .none
        
        // buttons
        cell.editAddButton.tag = indexPath.row
        cell.editAddButton.addTarget(self, action: #selector(addToInventory), for: .touchUpInside)
       
        return cell
    }
    
    func addToInventory(sender: UIButton){
        
        titleString = resultsArray[sender.tag]
        if let title = titleString, title != "" {
            print("----titleString is : --- \(title)")
            store.scannedItemToAdd = title
            store.scannedItemIndex = sender.tag
            print("scanned Item index is \(store.scannedItemIndex)")
            performSegue(withIdentifier: "addScannedItem", sender: self)
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if titleString != nil, titleString != "" {
            return true
        }
        return false
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

