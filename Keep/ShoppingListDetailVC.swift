//
//  ShoppingListDetailVC.swift
//  Keep
//
//  Created by Luna An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift
import MGSwipeTableCell
import NotificationCenter

class ShoppingListDetailVC: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let store = DataStore.sharedInstance
    var name:String?
    var uniqueID: String = EmptyString.none
    var itemToAddToStock: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.allowsMultipleSelection = true
        navigationItem.title = name?.capitalized
        definesPresentationContext = true
        NotificationCenter.default.addObserver(forName: NotificationName.refreshItemList, object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        shareList()
    }
    
    
    @IBAction func addItemBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: Identifiers.Segue.addItemToSL, sender: nil)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = emptyState.listItem
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = emptyState.messageForItems
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
      
    func configureSwipeButtons(cell:ListDetailCell, indexPath: IndexPath){
        let deleteButton = MGSwipeButton(title: EmptyString.none, icon: UIImage(named:ImageName.delete1), backgroundColor: Colors.salmon) { (sender: MGSwipeTableCell) -> Bool in
            
            let predicate = NSPredicate(format: Filters.listUniqueID, self.uniqueID)
            let filteredItems = self.store.allShoppingItems.filter(predicate)
            
            let realm = try! Realm()
            
            try! realm.write {
                let predicate2 = NSPredicate(format: Filters.uniqueID, self.uniqueID)
                let filteredList2 = self.store.allShopingLists.filter(predicate2).first
                
                realm.delete(filteredItems[indexPath.row])
                filteredList2?.numOfItems -= 1
            }
            self.tableView.reloadData()
            return true
        }

        cell.rightButtons = [deleteButton]
        cell.rightExpansion.buttonIndex = 0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.Segue.addItemToSL {
            let dest = segue.destination as! AddItemVC
            dest.uniqueID = uniqueID
        } else if segue.identifier == Identifiers.Segue.moveToStock {
            let dest = segue.destination as! AddScannedItemVC
            if let item = self.itemToAddToStock {
                dest.itemToAdd = item
            }
        }
    }
}

extension ShoppingListDetailVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let predicate = NSPredicate(format: Filters.listUniqueID, uniqueID)
        let filteredItems = store.allShoppingItems.filter(predicate)
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:Identifiers.Cell.listDetailCell, for: indexPath) as! ListDetailCell
        
        let predicate = NSPredicate(format: Filters.listUniqueID, uniqueID)
        let filteredItems = store.allShoppingItems.filter(predicate)
        cell.titleLabel.text = filteredItems[indexPath.row].name
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        
        if filteredItems[indexPath.row].isPurchased == true {
            cell.titleLabel.textColor = Colors.whiteFour
            cell.checkBoxImgView.image = #imageLiteral(resourceName: "ChecklistActive2")
            cell.moveButton.isHidden = false
        } else {
            cell.titleLabel.textColor = UIColor(red: 77/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1)
            cell.checkBoxImgView.image = #imageLiteral(resourceName: "ChecklistBase2")
            cell.moveButton.isHidden = true
        }
        
        cell.moveButton.tag = indexPath.row
        cell.moveButton.addTarget(self, action: #selector(buttonActions), for: .touchUpInside)
        cell.tapAction = { cell in }
        configureSwipeButtons(cell: cell, indexPath: indexPath)
        return cell
    }
    
   func buttonActions(sender:UIButton){
        let predicate = NSPredicate(format: Filters.listUniqueID, uniqueID)
        let filteredItems = store.allShoppingItems.filter(predicate)
        itemToAddToStock = filteredItems[sender.tag].name
        if self.itemToAddToStock != nil {
            performSegue(withIdentifier: Identifiers.Segue.moveToStock, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let predicate = NSPredicate(format: Filters.listUniqueID, uniqueID)
        let filteredItems = store.allShoppingItems.filter(predicate)
        
        let realm = try! Realm()
        try! realm.write {
            if filteredItems[indexPath.row].isPurchased == false {
                filteredItems[indexPath.row].isPurchased = true
            } else {
                filteredItems[indexPath.row].isPurchased = false
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func shareList(){
        let predicate = NSPredicate(format: Filters.listUniqueID, uniqueID)
        let filteredItems = store.allShoppingItems.filter(predicate)
        var emptyString = String()
        let newLine = Labels.lineBreak
        
        for item in filteredItems {
            emptyString += item.name + (newLine)
        }
        
        let activityController = UIActivityViewController(activityItems: [emptyString], applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = view
        activityController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        present(activityController, animated: true, completion: nil)
    }
}

