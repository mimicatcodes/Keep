//
//  MainViewController.swift
//  Keep
//
//  Created by Luna An on 1/20/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift
import MGSwipeTableCell

class MainViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate  {
    
    // TODO: Tableviewrowaction - custom font + image!

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
    
    @IBOutlet weak var fridgeLabel: UILabel!
    @IBOutlet weak var freezerLabel: UILabel!
    @IBOutlet weak var pantryLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    
    @IBOutlet var addButtons: [UIButton]! {
        didSet {
            addButtons.forEach {
                $0.isHidden = true
                $0.alpha = 0.0
            }
        }
    }
    
    let refresher = UIRefreshControl()

    var views: [UIView]!
    var buttons: [UIButton]!
    var labels: [UILabel]!
    var locations:[String] = [Locations.fridge, Locations.freezer, Locations.pantry, Locations.other]
    
    let store = DataStore.sharedInstance
    var selectedIndex: Int = 0
    let formatter = DateFormatter()
    var plusButtonIsRotated = false
    
    var itemToEdit: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views = [fridgeView, freezerView, pantryView, otherView]
        buttons = [fridgeButton, freezerButton, pantryButton, otherButton]
        labels = [fridgeLabel, freezerLabel, pantryLabel, otherLabel]
        setupInitialButtonStatus()
        
        if #available (iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
        
        refresher.tintColor = Colors.lightTeal
        //refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        tableView.allowsMultipleSelection = true
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView() // Remove empty cells
        formatDates()
        notificationAddObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dismissBtns()
        tableView.reloadData()
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    @IBAction func dismissButtons(_ sender: Any) {
        dismissBtns()
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        animateAddButtons()
    }
    
    @IBAction func didPressStockSection(_ sender: UIButton) {
        for (i,button) in buttons.enumerated() {
            if i == sender.tag {
                store.buttonStatus = locations[i]
                print("Selected sender.tag value is --------\(sender.tag)")
                button.isSelected = true
                button.setTitleColor(Colors.lightTeal, for: .selected)
                views[i].backgroundColor = Colors.lightTeal
                labels[i].textColor = UIColor.white
                tableView.reloadData()
            } else {
                print("NOT selected sender.tag value is --------\(sender.tag)")
                button.isSelected = false
                button.setTitleColor(Colors.warmGreyThree, for: .normal)
                views[i].backgroundColor = Colors.whiteTwo
                labels[i].textColor = Colors.warmGreyThree
                tableView.reloadData()
            }
            dismissBtns()
        }
        print("the button status is-------\(store.buttonStatus)")
    }
    
    
//    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
//        return UIImage(named: "sample3")
//    }
    
    func refreshTableView(){
        tableView.reloadData()
        refresher.endRefreshing()
    }
    
    func setupInitialButtonStatus(){
        addButtons.forEach {
            $0.layer.cornerRadius = 20
            $0.layer.borderWidth = 2
            $0.layer.borderColor = Colors.tealish.cgColor
        }
        buttons.first?.isSelected = true
        buttons.first?.isSelected = true
        labels.first?.textColor = .white
        views.first?.backgroundColor = Colors.lightTeal
    }
    
    func dismissBtns(){
        if plusButtonIsRotated == true {
            plusButton.transform = CGAffineTransform(rotationAngle: CGFloat(0).degreesToRadians)
            addButtons.forEach {
                $0.isHidden = true
                $0.alpha = 1.0
            }
            plusButtonIsRotated = false
        }
    }
    
    func notificationAddObserver(){
        NotificationCenter.default.addObserver(forName: NotificationName.refreshMainTV, object: nil, queue: nil) { notification in
            print("notification is \(notification)")
            self.tableView.reloadData()
        }
    }

    func animateAddButtons() {
        view.layoutIfNeeded()
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
        
        if segue.identifier == Identifiers.Segue.editIems {
            let dest = segue.destination as! AddItemsVC
            dest.itemToEdit = itemToEdit
            print(itemToEdit ?? "******************* item To edit")
        }
    }
}


extension MainViewController: UITableViewDataSource {
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
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissBtns()
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
        configureSwipeButtons(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureSwipeButtons(cell:StockCell, indexPath: IndexPath){
        
        let deleteButton = MGSwipeButton(title: "", icon: UIImage(named:"Delete2"), backgroundColor: Colors.salmon){ (sender: MGSwipeTableCell) -> Bool in
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

            return true
        }
        
        let editButton = MGSwipeButton(title: "", icon: UIImage(named:"EditGrey2"), backgroundColor: Colors.pinkishGrey) { (sender: MGSwipeTableCell) -> Bool in
            switch self.store.buttonStatus {
            case Locations.fridge:
                self.itemToEdit = self.store.fridgeItems.filter(Filters.category, self.store.fridgeSectionNames[indexPath.section])[indexPath.row]
                print(self.itemToEdit?.name ?? "NO VALUE")
                
            case Locations.freezer:
                self.itemToEdit = self.store.freezerItems.filter(Filters.category, self.store.freezerSectionNames[indexPath.section])[indexPath.row]
                print(self.itemToEdit?.name ?? "NO VALUE")
                
            case Locations.pantry:
                self.itemToEdit = self.store.pantryItems.filter(Filters.category, self.store.pantrySectionNames[indexPath.section])[indexPath.row]
                print(self.itemToEdit?.name ?? "NO VALUE")
                
            case Locations.other:
                self.itemToEdit = self.store.otherItems.filter(Filters.category, self.store.otherSectionNames[indexPath.section])[indexPath.row]
                print(self.itemToEdit?.name ?? "NO VALUE")
            default:
                break
            }
            
            self.performSegue(withIdentifier: Identifiers.Segue.editIems, sender: nil)
            return true
        }
        
        //deleteButton.setPadding(30)
        cell.rightButtons = [deleteButton, editButton]
        cell.rightExpansion.buttonIndex = 0
    }

    /*
    
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
        
        delete.backgroundColor = Colors.salmon
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            
            switch self.store.buttonStatus {
            case Locations.fridge:
                self.itemToEdit = self.store.fridgeItems.filter(Filters.category, self.store.fridgeSectionNames[indexPath.section])[indexPath.row]
                print(self.itemToEdit?.name ?? "NO VALUE")

            case Locations.freezer:
                self.itemToEdit = self.store.freezerItems.filter(Filters.category, self.store.freezerSectionNames[indexPath.section])[indexPath.row]
                 print(self.itemToEdit?.name ?? "NO VALUE")
                
            case Locations.pantry:
                self.itemToEdit = self.store.pantryItems.filter(Filters.category, self.store.pantrySectionNames[indexPath.section])[indexPath.row]
                 print(self.itemToEdit?.name ?? "NO VALUE")
                
            case Locations.other:
                self.itemToEdit = self.store.otherItems.filter(Filters.category, self.store.otherSectionNames[indexPath.section])[indexPath.row]
                 print(self.itemToEdit?.name ?? "NO VALUE")
            default:
                break
            }
            
            self.performSegue(withIdentifier: Identifiers.Segue.editIems, sender: nil)
        }
        
        //edit.backgroundColor = Colors.dodgerBlue
    
        return [delete, edit]
    }
 */
    
}




