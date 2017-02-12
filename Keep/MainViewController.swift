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
    
    @IBOutlet weak var menuBarView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var views: [UIView]!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var addButtons: [UIButton]! {
        didSet {
            addButtons.forEach {
                $0.isHidden = true
                $0.alpha = 0.0
            }
        }
    }
    var selectedIndex: Int = 0
    let formatter = DateFormatter()
    
    var plusButtonIsRotated = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        plusButton.layer.cornerRadius = plusButton.frame.size.height / 2
        plusButton.layer.borderWidth = 2.0
        plusButton.layer.borderColor = MAIN_COLOR.cgColor
        
        plusButton.layer.shadowColor = UIColor.black.cgColor
        plusButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        plusButton.layer.masksToBounds = false
        plusButton.layer.shadowRadius = 1.0
        plusButton.layer.shadowOpacity = 0.3
      
        addButtons.forEach {
            $0.layer.cornerRadius = $0.frame.size.height/2
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            $0.layer.masksToBounds = false
            $0.layer.shadowRadius = 1.0
            $0.layer.shadowOpacity = 0.3
        }

        tableView.allowsMultipleSelection = true
        buttons[selectedIndex].isSelected = true
        views[selectedIndex].backgroundColor = MAIN_COLOR
        didPressStockSection(buttons[selectedIndex])
        tableView.tableFooterView = UIView()
        formatDates()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dismissBtns()
        tableView.reloadData()
    }
    
    @IBAction func dismissButtons(_ sender: Any) {
        dismissBtns()
    }
    
    func dismissBtns(){
        if self.plusButtonIsRotated == true {
            self.plusButton.transform = CGAffineTransform(rotationAngle: CGFloat(45).degreesToRadians)
            
            self.addButtons.forEach {
                $0.isHidden = true
                $0.alpha = 1.0
            }
            
            self.plusButtonIsRotated = false
        }

    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        animateAddButtons()
    }
    @IBAction func didPressStockSection(_ sender: UIButton) {
        
        let index_ = sender.tag
        
        switch index_ {
            
        case 0:
            store.buttonStatus = "Fridge"
            print("Fridge ---")
            
            tableView.reloadData()
        case 1:
            store.buttonStatus = "Freezer"
            print("Freezer-----")
            tableView.reloadData()
            
        case 2:
            store.buttonStatus = "Pantry"
            print("Pantry -----")
            tableView.reloadData()
        default:
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
            dismissBtns()
        }
    }
    
    func formatDates(){
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
        
    }
    
    func animateAddButtons() {
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveLinear, animations: {
            
            if !self.plusButtonIsRotated {
                self.plusButton.transform = CGAffineTransform(rotationAngle: CGFloat(45).degreesToRadians)
                
                self.addButtons.forEach {
                    $0.isHidden = false
                    $0.alpha = 1.0
                }
                
                self.plusButtonIsRotated = true
            } else {
                self.plusButton.transform = CGAffineTransform(rotationAngle: CGFloat(0).degreesToRadians)
                
                self.addButtons.forEach {
                    $0.isHidden = true
                    $0.alpha = 0.0
                }
                
                self.plusButtonIsRotated = false
            }
            
            
        }, completion: nil)
        
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
   
        switch store.buttonStatus {
            
        case "Fridge":
            
            let filteredFridgeItem = store.fridgeItems.filter("category == %@", store.fridgeSectionNames[indexPath.section])[indexPath.row]
            configureCells(cell: cell, indexPath: indexPath, filteredItem: filteredFridgeItem)
        case "Freezer":
            
            let filteredFreezerItem = store.freezerItems.filter("category == %@", store.freezerSectionNames[indexPath.section])[indexPath.row]
            configureCells(cell: cell, indexPath: indexPath, filteredItem: filteredFreezerItem)
            
        case "Pantry":
            let filteredPantryItem = store.pantryItems.filter("category == %@", store.pantrySectionNames[indexPath.section])[indexPath.row]
            configureCells(cell: cell, indexPath: indexPath, filteredItem: filteredPantryItem)
            
        case "Other":
            let filteredOtherItem = store.otherItems.filter("category == %@", store.otherSectionNames[indexPath.section])[indexPath.row]
            configureCells(cell: cell, indexPath: indexPath, filteredItem: filteredOtherItem)
            default:
            break
        }
        
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissBtns()
    }
    
    func configureCells(cell:StockCell, indexPath: IndexPath, filteredItem: Item ){
        
        let today = Date()
        var expDate = Date()
        var daysLeft: Int = 0
        
        cell.itemTitleLabel.text = filteredItem.name.lowercased().capitalized
        let pDate = formatter.string(from: filteredItem.purchaseDate)
        cell.purchaseDate.text = "Purchased on " + pDate
        expDate = filteredItem.exp
        daysLeft = daysBetweenTwoDates(start: today, end: expDate)
        let realm = try! Realm()
        try! realm.write {
            if daysLeft < 0 {
                filteredItem.isExpired = true
            } else if daysLeft >= 0 && daysLeft < 4  {
                filteredItem.isExpiring = true
            } else {
                filteredItem.isExpiring = false
            }
        }
        
        configureExpireLabels(cell: cell, daysLeft: daysLeft)
        cell.quantityLabel.text = "x " + filteredItem.quantity

    }
    
    func configureExpireLabels(cell: StockCell, daysLeft: Int){
        if daysLeft == 0 {
            cell.expDateLabel.text = "Expiring today"
            cell.expDateLabel.textColor = EXPIRING_WARNING_COLOR
        } else if daysLeft == 1 {
            cell.expDateLabel.text = "\(daysLeft) day left"
            cell.expDateLabel.textColor = EXPIRING_WARNING_COLOR
        } else if daysLeft == 2 || daysLeft == 3 {
            cell.expDateLabel.text = "\(daysLeft) days left"
            cell.expDateLabel.textColor = EXPIRING_WARNING_COLOR
        } else if daysLeft > 3 {
            cell.expDateLabel.text = "\(daysLeft) days left"
            cell.expDateLabel.textColor = MAIN_BUTTON_LABEL_GRAY
        } else  {
            cell.expDateLabel.text = "Expired!"
            cell.expDateLabel.textColor = EXPIRING_WARNING_COLOR
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        dismissBtns()
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let realm = try! Realm()
            
            
            switch self.store.buttonStatus {
            case "Fridge":
                let itemToBeDeleted = self.store.fridgeItems.filter("category == %@", self.store.fridgeSectionNames[indexPath.section])[indexPath.row]
                
                try! realm.write {
                    print("\(itemToBeDeleted) has been deleted")
                    realm.delete(itemToBeDeleted)
                }
                self.tableView.reloadData()
                print("Deleted an item from a Fridge")
                
            case "Freezer":
                let itemToBeDeleted = self.store.freezerItems.filter("category == %@", self.store.freezerSectionNames[indexPath.section])[indexPath.row]
                try! realm.write {
                    print("\(itemToBeDeleted) has been deleted")
                    realm.delete(itemToBeDeleted)
                }
                self.tableView.reloadData()
                print("Deleted an item from Freezer")
                
            case "Pantry":
                let itemToBeDeleted = self.store.pantryItems.filter("category == %@", self.store.pantrySectionNames[indexPath.section])[indexPath.row]
                try! realm.write {
                    print("\(itemToBeDeleted) has been deleted")
                    realm.delete(itemToBeDeleted)
                }
                self.tableView.reloadData()
                print("Deleted an item from Pantry")
                
            case "Other":
                let itemToBeDeleted = self.store.otherItems.filter("category == %@", self.store.otherSectionNames[indexPath.section])[indexPath.row]
                try! realm.write {
                    print("\(itemToBeDeleted) has been deleted")
                    realm.delete(itemToBeDeleted)
                }
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
