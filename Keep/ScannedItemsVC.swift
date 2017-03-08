//
//  ScanReceiptsVC.swift
//  Keep
//
//  Created by Luna An on 2/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ScannedItemsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    let store = DataStore.sharedInstance
    var resultsArray = [String]()
    var titleString:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        topView.underlinedBorder()

        if titleString == nil {
        NotificationCenter.default.addObserver(forName: NotificationName.refreshScannedItems, object: nil, queue: nil) { notification in
            self.resultsArray.remove(at: self.store.scannedItemIndex!)
            self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Identifiers.Segue.unwindToMain, sender: self)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func addToInventory(sender: UIButton){
        titleString = resultsArray[sender.tag]
        
        if let title = titleString, title != EmptyString.none {
            store.scannedItemToAdd = title
            store.scannedItemIndex = sender.tag
            performSegue(withIdentifier: Identifiers.Segue.addScannedItem, sender: self)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if titleString != nil, titleString != EmptyString.none {
            return true
        }
        return false
    }
    
    func configureSwipeButtons(cell:ScannedItemCell, indexPath: IndexPath){
        let deleteButton = MGSwipeButton(title: EmptyString.none, icon: UIImage(named:ImageName.delete2), backgroundColor: Colors.salmon){ (sender: MGSwipeTableCell) -> Bool in
            self.resultsArray.remove(at: indexPath.row)
            self.tableView.reloadData()
            return true
        }
        
        cell.rightButtons = [deleteButton]
        cell.rightExpansion.buttonIndex = 0
    }
}

extension ScannedItemsVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Cell.scannedItemCell, for: indexPath) as! ScannedItemCell
        
        cell.titleLabel.text = resultsArray[indexPath.row]
        cell.selectionStyle = .none
        cell.editAddButton.layer.cornerRadius = 8
        cell.editAddButton.tag = indexPath.row
        cell.editAddButton.addTarget(self, action: #selector(addToInventory), for: .touchUpInside)
        configureSwipeButtons(cell: cell, indexPath: indexPath)

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            resultsArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

