//
//  MainViewController.swift
//  Keep
//
//  Created by Luna An on 1/20/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let store = DataStore.sharedInstance
    
    // var notificationToken: NotificationToken?
    
    var selectedIndex: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var underBars: [UIView]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        buttons[selectedIndex].isSelected = true
        underBars[selectedIndex].backgroundColor = UIColor.darkGray
        didPressStockSection(buttons[selectedIndex])

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }
    
    @IBAction func didPressStockSection(_ sender: UIButton) {
        
        let previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        buttons[selectedIndex].isEnabled = false
        buttons[previousIndex].isEnabled = true
        
        // Set previous button to the non-selected state
        buttons[previousIndex].isSelected = false

        sender.isSelected = true
        
        switch selectedIndex {
            
        case 0:
            navigationItem.title = "Fridge"
            store.buttonStatus = "Fridge"
            print("Fridge ---")
            tableView.reloadData()
        case 1:
            navigationItem.title = "Freezer"
            store.buttonStatus = "Freezer"
            print("Freezer-----")
            tableView.reloadData()
            
        case 2:
            navigationItem.title = "Pantry"
            store.buttonStatus = "Pantry"
            print("Pantry -----")
            tableView.reloadData()
        default:
            navigationItem.title = "Other"
            store.buttonStatus = "Other"
            print("Other ------")
            tableView.reloadData()
            
        }
        
        // Button underbar background color changes when tapped.
        if buttons[selectedIndex].isHighlighted {
            
            underBars[selectedIndex].backgroundColor = UIColor.darkGray
            underBars[previousIndex].backgroundColor = UIColor.clear
        }
        
    }
    
    // MARK: - TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var count = 0
        
        switch store.buttonStatus {
            
            case "Fridge":
            count = store.fridgeSectionNames.count
            case "Freezer":
            count = store.freezerSectionNames.count
            case "Pantry":
            count = store.pantrySectionNames.count
            case "Other":
            count = store.otherSectionNames.count
            default:
            count = 0
            
        }
       
        return count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title = ""
        
        switch store.buttonStatus {
            
        case "Fridge":
            title = store.fridgeSectionNames[section]
        case "Freezer":
            title = store.freezerSectionNames[section]
        case "Pantry":
            title = store.pantrySectionNames[section]
        case "Other":
            title = store.otherSectionNames[section]
        default:
            break
        }

        return title
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        switch store.buttonStatus {
            
        case "Fridge":
            count = store.fridgeItems.filter("category == %@", store.fridgeSectionNames[section]).count
        case "Freezer":
            count = store.freezerItems.filter("category == %@", store.freezerSectionNames[section]).count
        case "Pantry":
            count = store.pantryItems.filter("category == %@", store.pantrySectionNames[section]).count
        case "Other":
            count = store.otherItems.filter("category == %@", store.otherSectionNames[section]).count
        default:
            break
        }
        
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockCell
        
        switch store.buttonStatus {
            
        case "Fridge":
            cell.itemTitleLabel.text = store.fridgeItems.filter("category == %@", store.fridgeSectionNames[indexPath.section])[indexPath.row].name
        case "Freezer":
            cell.itemTitleLabel.text = store.freezerItems.filter("category == %@", store.freezerSectionNames[indexPath.section])[indexPath.row].name
        case "Pantry":
            cell.itemTitleLabel.text = store.pantryItems.filter("category == %@", store.pantrySectionNames[indexPath.section])[indexPath.row].name
        case "Other":
            cell.itemTitleLabel.text = store.otherItems.filter("category == %@", store.otherSectionNames[indexPath.section])[indexPath.row].name
        default:
            break
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    // MARK: - Methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            print("********** The delete button is tapped ********** ")
            let realm = try! Realm()
            
            switch self.store.buttonStatus {
                case "Fridge":
                    
                    try! realm.write {
                        let itemToBeDeleted = self.store.fridgeItems[indexPath.row]
                        print("\(itemToBeDeleted) has been deleted")
                        realm.delete(itemToBeDeleted)}
                        self.tableView.reloadData()
                        print("Deleted an item from a fridge")

                case "Freezer":
                    try! realm.write {
                        let itemToBeDeleted = self.store.freezerItems[indexPath.row]
                        print("\(itemToBeDeleted) has been deleted")
                        realm.delete(itemToBeDeleted)}
                        self.tableView.reloadData()
                        print("Deleted an item from a fridge")

                case "Pantry":
                    try! realm.write {
                        let itemToBeDeleted = self.store.pantryItems[indexPath.row]
                        print("\(itemToBeDeleted) has been deleted")
                        realm.delete(itemToBeDeleted)}
                        self.tableView.reloadData()
                        print("Deleted an item from a fridge")

                case "Other":
                    try! realm.write {
                        let itemToBeDeleted = self.store.otherItems[indexPath.row]
                        print("\(itemToBeDeleted) has been deleted")
                        realm.delete(itemToBeDeleted)}
                        self.tableView.reloadData()
                        print("Deleted an item from a fridge")

                default:
                        break
            }
            
            
            
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath
            
            print("EDIT Tapped")
            
        }
        
        return [delete, edit]
    }

}

class StockCell:UITableViewCell {
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var expDateLabel: UILabel!

    
}
