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
    
    @IBOutlet weak var menuBarView: UIView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fridgeButton: UIButton!
    @IBOutlet weak var freezerButton: UIButton!
    @IBOutlet weak var pantryButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    @IBOutlet weak var fridgeView: UIView!
    @IBOutlet weak var freezerView: UIView!
    @IBOutlet weak var pantryView: UIView!
    @IBOutlet weak var otherView: UIView!
    
    var views: [UIView]!
    var buttons: [UIButton]!
    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var addButtons: [UIButton]! {
        didSet {
            addButtons.forEach {
                $0.isHidden = true
                $0.alpha = 0.0
            }
        }
    }
    
    let store = DataStore.sharedInstance
    var selectedIndex: Int = 0
    let formatter = DateFormatter()
    var plusButtonIsRotated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        views = [fridgeView, freezerView, pantryView, otherView]
        buttons = [fridgeButton, freezerButton, pantryButton, otherButton]
        addButtons.forEach {
            $0.layer.cornerRadius = 20
            $0.layer.borderWidth = 2
            $0.layer.borderColor = Colors.tealish.cgColor
        }
        tableView.allowsMultipleSelection = true
        buttons[selectedIndex].isSelected = true
        views[selectedIndex].backgroundColor = Colors.tealish
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
            self.plusButton.transform = CGAffineTransform(rotationAngle: CGFloat(0).degreesToRadians)
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
            store.buttonStatus = Locations.fridge
            tableView.reloadData()
        case 1:
            store.buttonStatus = Locations.freezer
            tableView.reloadData()
        case 2:
            store.buttonStatus = Locations.pantry
            tableView.reloadData()
        default:
            store.buttonStatus = Locations.other
            tableView.reloadData()
        }
        
        for (i,button) in buttons.enumerated() {
            if i == index_ {
                button.isSelected = true
                button.setTitleColor(Colors.tealish, for: .selected)
                views[i].backgroundColor = Colors.tealish
                labels[i].textColor = UIColor.white
            } else {
                button.isSelected = false
                button.setTitleColor(Colors.warmGreyThree, for: .normal)
                views[i].backgroundColor = Colors.whiteTwo
                labels[i].textColor = Colors.warmGreyThree
            }
            dismissBtns()
        }
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
    
    func formatDates(){
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        var count = 0
        switch store.buttonStatus {
        case Locations.fridge:
            count = store.fridgeSectionNames.count
        case Locations.freezer:
            count = store.freezerSectionNames.count
        case Locations.pantry:
            count = store.pantrySectionNames.count
        case Locations.other:
            count = store.otherSectionNames.count
        default:
            count = 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: Fonts.montserratRegular, size: 12)
        header.textLabel?.textColor = UIColor.white
        header.contentView.backgroundColor = Colors.tealish
        header.textLabel?.textAlignment = .center
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title = ""
        
        switch store.buttonStatus {
        case Locations.fridge:
            title = store.fridgeSectionNames[section]
        case Locations.freezer:
            title = store.freezerSectionNames[section]
        case Locations.pantry:
            title = store.pantrySectionNames[section]
        case Locations.other:
            title = store.otherSectionNames[section]
        default:
            break
        }
        return title
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        switch store.buttonStatus {
        case Locations.fridge:
            count = store.fridgeItems.filter(Filters.category, store.fridgeSectionNames[section]).count
        case Locations.freezer:
            count = store.freezerItems.filter(Filters.category, store.freezerSectionNames[section]).count
        case Locations.pantry:
            count = store.pantryItems.filter(Filters.category, store.pantrySectionNames[section]).count
        case Locations.other:
            count = store.otherItems.filter(Filters.category, store.otherSectionNames[section]).count
        default:
            break
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Cell.stockCell, for: indexPath) as! StockCell
        
        switch store.buttonStatus {
            
        case Locations.fridge:
            
            let filteredFridgeItem = store.fridgeItems.filter(Filters.category, store.fridgeSectionNames[indexPath.section])[indexPath.row]
            configureCells(cell: cell, indexPath: indexPath, filteredItem: filteredFridgeItem)
        case Locations.freezer:
            
            let filteredFreezerItem = store.freezerItems.filter(Filters.category, store.freezerSectionNames[indexPath.section])[indexPath.row]
            configureCells(cell: cell, indexPath: indexPath, filteredItem: filteredFreezerItem)
            
        case Locations.pantry:
            let filteredPantryItem = store.pantryItems.filter(Filters.category, store.pantrySectionNames[indexPath.section])[indexPath.row]
            configureCells(cell: cell, indexPath: indexPath, filteredItem: filteredPantryItem)
            
        case Locations.other:
            let filteredOtherItem = store.otherItems.filter(Filters.category, store.otherSectionNames[indexPath.section])[indexPath.row]
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
            cell.expDateLabel.textColor = Colors.pastelRed
        } else if daysLeft == 1 {
            cell.expDateLabel.text = "\(daysLeft) day left"
            cell.expDateLabel.textColor = Colors.pastelRed

        } else if daysLeft == 2 || daysLeft == 3 {
            cell.expDateLabel.text = "\(daysLeft) days left"
            cell.expDateLabel.textColor = Colors.pastelRed

        } else if daysLeft > 3 {
            cell.expDateLabel.text = "\(daysLeft) days left"
            cell.expDateLabel.textColor = Colors.warmGreyThree
        } else  {
            cell.expDateLabel.text = "Expired!"
            cell.expDateLabel.textColor = Colors.pastelRed

        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        dismissBtns()
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let realm = try! Realm()
            
            switch self.store.buttonStatus {
            case Locations.fridge:
                let itemToBeDeleted = self.store.fridgeItems.filter(Filters.category, self.store.fridgeSectionNames[indexPath.section])[indexPath.row]
                
                try! realm.write {
                    print("\(itemToBeDeleted) has been deleted")
                    realm.delete(itemToBeDeleted)
                }
                self.tableView.reloadData()
                print("Deleted an item from a Fridge")
                
            case Locations.freezer:
                let itemToBeDeleted = self.store.freezerItems.filter(Filters.category, self.store.freezerSectionNames[indexPath.section])[indexPath.row]
                try! realm.write {
                    print("\(itemToBeDeleted) has been deleted")
                    realm.delete(itemToBeDeleted)
                }
                self.tableView.reloadData()
                print("Deleted an item from Freezer")
                
            case Locations.pantry:
                let itemToBeDeleted = self.store.pantryItems.filter(Filters.category, self.store.pantrySectionNames[indexPath.section])[indexPath.row]
                try! realm.write {
                    print("\(itemToBeDeleted) has been deleted")
                    realm.delete(itemToBeDeleted)
                }
                self.tableView.reloadData()
                print("Deleted an item from Pantry")
                
            case Locations.other:
                let itemToBeDeleted = self.store.otherItems.filter(Filters.category, self.store.otherSectionNames[indexPath.section])[indexPath.row]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
}

class StockCell:UITableViewCell {
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var expDateLabel: UILabel!
    @IBOutlet weak var purchaseDate: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
}

