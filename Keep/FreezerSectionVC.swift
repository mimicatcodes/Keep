//
//  FreezerSectionVC.swift
//  Keep
//
//  Created by Luna An on 1/2/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

class FreezerSectionVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
        let searchSampleItems = bakery
        
        struct FridgeItems {
            
        var sectionName: String?
        var sectionItems: [item]?
        }
        
        struct item {
            var name: String
            var expDate: String?
            var quantity: String?
            var category: String
        }
        
        var fridgeItemsArray = [FridgeItems]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            generateSampleItems()
            tableView.allowsMultipleSelection = true
        }
        
        // MARK: - TableView Methods
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return fridgeItemsArray.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            var itemCount = 0
            if let items = fridgeItemsArray[section].sectionItems {
                itemCount = items.count
            } else {
                itemCount = 0
            }
            
            return itemCount
        }
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return fridgeItemsArray[section].sectionName
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "freezerCell", for: indexPath) as! FreezerCell
            
            if let items = fridgeItemsArray[indexPath.section].sectionItems?[indexPath.row] {
                cell.itemExpLabel.text = items.expDate
                cell.itemTitleLabel.text = items.name
                cell.itemQuantityLabel.text = items.quantity
            }
            
            cell.accessoryType = cell.isSelected ? .checkmark : .none
            cell.selectionStyle = .none // to prevent cells from being "highlighted"
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        // MARK: - Methods
        
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                
                print("********** The delete button is tapped ********** ")
                
            }
            
            let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
                // share item at indexPath
                
                //self.performSegue(withIdentifier: "addEvent", sender: nil)
                
            }
            
            return [delete, edit]
        }
        
        func generateSampleItems(){
            
            let item1 = item(name: "Apple", expDate: "None", quantity: "5", category: "Produce")
            let item2 = item(name: "Ice Cream", expDate: "None", quantity: "5", category: "Dairy")
            let item3 = item(name: "Soy Sauce", expDate: "Unknown", quantity: "5", category: "Condiments")
            let item4 = item(name: "Butter", expDate: "01/08/16", quantity: "1", category: "Butter and Margarine")
            let item5 = item(name: "Cheese", expDate: "02/02/16", quantity: "1", category: "Dairy")
            let item6 = item(name: "Margarine", expDate: "01/08/16", quantity: "1", category: "Butter and Margarine")
            let item7 = item(name: "Cream Cheese", expDate: "01/08/16", quantity: "1", category: "Dairy")
            let item8 = item(name: "Orange", expDate: "Unknown", quantity: "10", category: "Produce")
            
            
            let fridgeItem1 = FridgeItems(sectionName: "Produce", sectionItems: [item1, item8])
            let fridgeItem2 = FridgeItems(sectionName: "Dairy", sectionItems: [item2, item5, item7])
            let fridgeItem3 = FridgeItems(sectionName: "Butter and Margarine", sectionItems: [item4, item6])
            let fridgeItem4 = FridgeItems(sectionName: "Condiments", sectionItems: [item3])
            
            fridgeItemsArray = [fridgeItem1, fridgeItem2, fridgeItem3, fridgeItem4]
            
        }
        
        // Search Bar
        
        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            return true
        }
        
    }
    
    class FreezerCell:UITableViewCell {
    
        @IBOutlet weak var itemTitleLabel: UILabel!
        @IBOutlet weak var itemQuantityLabel: UILabel!
        @IBOutlet weak var itemExpLabel: UILabel!
    }


