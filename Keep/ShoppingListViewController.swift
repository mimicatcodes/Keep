//
//  ShoppingListViewController.swift
//  Keep
//
//  Created by Luna An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift
import MGSwipeTableCell
import NotificationCenter

class ShoppingListViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let store = DataStore.sharedInstance
    var id = String()
    let formatter = DateFormatter()
    var listToEdit: ShoppingList?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        definesPresentationContext = true
        formatDates()
        tableView.separatorColor = Colors.whiteThree
        NotificationCenter.default.addObserver(forName: NotificationName.refreshTableview, object: nil, queue: nil) { notification in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
//    
//    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
//        return UIImage(named: "sample3")
//    }
    
    func configureSwipeButtons(cell:ShoppingListCell, indexPath: IndexPath){
        
        let rightButton1 = MGSwipeButton(title: EmptyString.none, icon: UIImage(named:ImageName.delete2), backgroundColor: Colors.salmon) { (sender: MGSwipeTableCell) -> Bool in
            self.alertForDelete(indexPath: indexPath)
            return true
        }
        
        let rightButton2 = MGSwipeButton(title: EmptyString.none, icon: UIImage(named:ImageName.editGrey2), backgroundColor: Colors.pinkishGrey)  { (sender: MGSwipeTableCell) -> Bool in
            self.listToEdit = self.store.allShopingLists[indexPath.row]
            self.performSegue(withIdentifier: Identifiers.Segue.addList, sender: self)
            return true
        }
        
        cell.rightButtons = [rightButton1, rightButton2]
        cell.rightExpansion.buttonIndex = 0
    }
    
    func alertForDelete(indexPath: IndexPath){
        let alertController = UIAlertController(title: "Are you sure you want to delete this list?",  message: "All items in the list will be deleted.", preferredStyle: .alert)
    
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { action in
            print("Delete pressed")
            let uniqueID = self.store.allShopingLists[indexPath.row].uniqueID
            let selectedList = self.store.allShopingLists[indexPath.row]
            
            let predicate = NSPredicate(format: Filters.listUniqueID, uniqueID)
            let filteredItems = self.store.allShoppingItems.filter(predicate)
            
            let realm = try! Realm()
            
            try! realm.write {
                realm.delete(filteredItems)
                realm.delete(selectedList)
            }
            
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("Cancel Pressed")
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func formatDates() {
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.Segue.showItems {
            if let index = tableView.indexPathForSelectedRow?.row {
                let selectedList = store.allShopingLists[index]
                let dest = segue.destination as! ShoppingListDetailVC
                dest.name = selectedList.title
                dest.uniqueID = selectedList.uniqueID
                print(selectedList.uniqueID)
            }
        } else if segue.identifier == Identifiers.Segue.addList {
                let dest = segue.destination as! AddListVC
                dest.listToEdit = listToEdit
        }
        let backItem = UIBarButtonItem()
        backItem.title = EmptyString.none
        navigationItem.backBarButtonItem = backItem
    }
}

extension ShoppingListViewController : UITableViewDelegate, UITableViewDataSource {
    func titleForIndexPath(_ indexPath: IndexPath) -> String {
        return store.allShopingLists[indexPath.row].title
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return store.allShopingLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Cell.shoppingListCell) as! ShoppingListCell
        cell.numOfItemsView.layer.borderWidth = 1.2
        cell.numOfItemsView.layer.borderColor = Colors.tealish.cgColor
        cell.numOfItemsView.backgroundColor = UIColor.clear
        cell.numOfItemsRemainingLabel.text = String(describing: store.allShopingLists[indexPath.row].numOfItems)
        cell.shoppingListTitleLabel.text = store.allShopingLists[indexPath.row].title.capitalized
        let createdAt = formatter.string(from:store.allShopingLists[indexPath.row].isCreatedAt)
        cell.createdAtLabel.text = createdAt
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        configureSwipeButtons(cell: cell, indexPath: indexPath)
        return cell
    }
}
