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
    
    var selectedIndex: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var views: [UIView]!
    @IBOutlet var labels: [UILabel]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        buttons[selectedIndex].isSelected = true
        views[selectedIndex].backgroundColor = MAIN_COLOR
        didPressStockSection(buttons[selectedIndex])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }
    
    @IBAction func didPressStockSection(_ sender: UIButton) {
        
        let index_ = sender.tag
        
        switch index_ {
            
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
        
        
        for (index,button) in buttons.enumerated() {
            
            if index == index_ {
                
                button.isSelected = true
                button.setTitleColor(MAIN_COLOR, for: .selected)
                views[index].backgroundColor = MAIN_COLOR
                labels[index].textColor = UIColor.white

            } else {
                
                button.isSelected = false
                button.setTitleColor(MAIN_BUTTON_LABEL_GRAY, for: .normal)
                views[index].backgroundColor = MAIN_BG_COLOR
                labels[index].textColor = MAIN_BUTTON_LABEL_GRAY
                
            }
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Montserrat-Regular", size: 12)
        header.textLabel?.textColor = UIColor.white
        header.contentView.backgroundColor = UIColor(red: 35/255.0, green: 213/255.0, blue: 185/255.0, alpha: 1)
        header.textLabel?.textAlignment = .center
        
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
        let today = Date()
        var expDate = Date()
        var daysLeft: Int = 0
        
        switch store.buttonStatus {
            
        case "Fridge":
            cell.itemTitleLabel.text = store.fridgeItems.filter("category == %@", store.fridgeSectionNames[indexPath.section])[indexPath.row].name
            cell.purchaseDate.text = "Purchased on " + store.fridgeItems.filter("category == %@", store.fridgeSectionNames[indexPath.section])[indexPath.row].purchaseDate
            expDate = store.fridgeItems.filter("category == %@", store.fridgeSectionNames[indexPath.section])[indexPath.row].exp
            daysLeft = daysBetweenTwoDates(start: today, end: expDate)
            configureExpireLabels(cell: cell, daysLeft: daysLeft)
            cell.quantityLabel.text = "x \(store.fridgeItems.filter("category == %@", store.fridgeSectionNames[indexPath.section])[indexPath.row].quantity)"
            
            
        case "Freezer":
            cell.itemTitleLabel.text = store.freezerItems.filter("category == %@", store.freezerSectionNames[indexPath.section])[indexPath.row].name
            cell.purchaseDate.text = "Purchased on \(store.freezerItems.filter("category == %@", store.freezerSectionNames[indexPath.section])[indexPath.row].purchaseDate)"
            expDate = store.freezerItems.filter("category == %@", store.freezerSectionNames[indexPath.section])[indexPath.row].exp
            daysLeft = daysBetweenTwoDates(start: today, end: expDate)
            configureExpireLabels(cell: cell, daysLeft: daysLeft)
            cell.quantityLabel.text = "x \(store.freezerItems.filter("category == %@", store.freezerSectionNames[indexPath.section])[indexPath.row].quantity)"
            
            
        case "Pantry":
            cell.itemTitleLabel.text = store.pantryItems.filter("category == %@", store.pantrySectionNames[indexPath.section])[indexPath.row].name
            cell.purchaseDate.text = "Purchased on \(store.pantryItems.filter("category == %@", store.pantrySectionNames[indexPath.section])[indexPath.row].purchaseDate)"
            expDate = store.pantryItems.filter("category == %@", store.pantrySectionNames[indexPath.section])[indexPath.row].exp
            daysLeft = daysBetweenTwoDates(start: today, end: expDate)
            configureExpireLabels(cell: cell, daysLeft: daysLeft)
            cell.quantityLabel.text = "x " + store.pantryItems.filter("category == %@", store.pantrySectionNames[indexPath.section])[indexPath.row].quantity
        case "Other":
            cell.itemTitleLabel.text = store.otherItems.filter("category == %@", store.otherSectionNames[indexPath.section])[indexPath.row].name
            cell.purchaseDate.text = "Purchased on " + store.otherItems.filter("category == %@", store.otherSectionNames[indexPath.section])[indexPath.row].purchaseDate
            expDate = store.otherItems.filter("category == %@", store.otherSectionNames[indexPath.section])[indexPath.row].exp
            daysLeft = daysBetweenTwoDates(start: today, end: expDate)
            configureExpireLabels(cell: cell, daysLeft: daysLeft)
            cell.quantityLabel.text = "x " + store.otherItems.filter("category == %@", store.otherSectionNames[indexPath.section])[indexPath.row].quantity

        default:
            break
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func configureExpireLabels(cell: StockCell, daysLeft: Int){
        if daysLeft == 0 {
            cell.expDateLabel.text = "Expiring today"
            cell.expDateLabel.textColor = EXPIRING_WARNING_COLOR
        } else if daysLeft == 1 {
            cell.expDateLabel.text = "\(daysLeft) day left"
            cell.expDateLabel.textColor = EXPIRING_WARNING_COLOR
        } else if daysLeft > 1 {
            cell.expDateLabel.text = "\(daysLeft) days left"
        } else if daysLeft > 1 && daysLeft < 4 {
            cell.expDateLabel.textColor = EXPIRING_WARNING_COLOR
        } else if daysLeft < 0 {
            cell.expDateLabel.text = "Expired!"
        }
    }
    
    // MARK: - Methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let realm = try! Realm()
            
            switch self.store.buttonStatus {
            case "Fridge":
                
                try! realm.write {
                    let itemToBeDeleted = self.store.fridgeItems[indexPath.row]
                    print("\(itemToBeDeleted) has been deleted")
                    realm.delete(itemToBeDeleted)}
                self.tableView.reloadData()
                print("Deleted an item from a Fridge")
                
            case "Freezer":
                try! realm.write {
                    let itemToBeDeleted = self.store.freezerItems[indexPath.row]
                    print("\(itemToBeDeleted) has been deleted")
                    realm.delete(itemToBeDeleted)}
                self.tableView.reloadData()
                print("Deleted an item from Freezer")
                
            case "Pantry":
                try! realm.write {
                    let itemToBeDeleted = self.store.pantryItems[indexPath.row]
                    print("\(itemToBeDeleted) has been deleted")
                    realm.delete(itemToBeDeleted)}
                self.tableView.reloadData()
                print("Deleted an item from Pantry")
                
            case "Other":
                try! realm.write {
                    let itemToBeDeleted = self.store.otherItems[indexPath.row]
                    print("\(itemToBeDeleted) has been deleted")
                    realm.delete(itemToBeDeleted)}
                self.tableView.reloadData()
                print("Deleted an item from Other")
                
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
    
    func daysBetweenTwoDates(start: Date, end: Date) -> Int{
        
            let currentCalendar = Calendar.current
        
            guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else { return 0 }
            guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else { return 0 }
            return end - start
        
    }
    
}

class StockCell:UITableViewCell {
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var expDateLabel: UILabel!
    @IBOutlet weak var purchaseDate: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    
}
