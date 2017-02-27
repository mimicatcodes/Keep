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

class ShoppingListViewController: UIViewController {
    // TODO: move activity view controller to the shoppinglist detail vc 
    // TODO: Delete alert
    
    @IBOutlet weak var tableView: UITableView!
    
    let store = DataStore.sharedInstance
    var id = ""
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        definesPresentationContext = true
        formatDates()
        tableView.separatorColor = Colors.whiteThree
        NotificationCenter.default.addObserver(forName: NotificationName.refreshTableview, object: nil, queue: nil) { notification in
            print("notification is \(notification)")
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addListTapped(_ sender: Any) {
        
        performSegue(withIdentifier: Identifiers.Segue.addList, sender: nil)
    }
    
    func deleteList(indexPath: IndexPath, uniqueID: String) {
        
        let filteredList = store.allShopingLists[indexPath.row]
        
        let predicate = NSPredicate(format: "list.uniqueID contains[c] %@", uniqueID)
        let filteredItems = store.allShoppingItems.filter(predicate)
        
        let realm = try! Realm()
        
        try! realm.write {
            print("From \(filteredList.title), + \(filteredItems.count) items deleted")

            realm.delete(filteredItems)
            realm.delete(filteredList)
        }
        
        tableView.reloadData()
    }
    
    func configureSwipeButtons(cell:ShoppingListCell, indexPath: IndexPath){
        id = self.store.allShopingLists[indexPath.row].uniqueID

        let rightButton1 = MGSwipeButton(title: "", icon: UIImage(named:"Delete2"), backgroundColor: Colors.salmon) { (sender: MGSwipeTableCell) -> Bool in
            self.deleteList(indexPath: indexPath, uniqueID: self.id)
//            self.createAlert(withTitle: "Are you sure you want to delete this list?")
            return true
        }
        
        let rightButton2 = MGSwipeButton(title: "", icon: UIImage(named:"EditGrey2"), backgroundColor: Colors.pinkishGrey)  { (sender: MGSwipeTableCell) -> Bool in
            self.editList(indexPath: indexPath, uniqueID: self.id)
            print("hello")
            return true
        }
        
        cell.rightButtons = [rightButton1, rightButton2]
        cell.rightExpansion.buttonIndex = 0
    }
    
    func formatDates() {
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
    }
    
    func editList(indexPath: IndexPath, uniqueID: String){
        performSegue(withIdentifier: Identifiers.Segue.addList, sender: nil)
    }
    
    func createAlert(withTitle:String) {
        let alert = UIAlertController(title: withTitle, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
            if id != "" {
                let dest = segue.destination as! AddListVC
                dest.listToEdit = store.allShopingLists.filter({$0.uniqueID == self.id}).first
                print("\(self.id) is passed to addLISTVC")
            }
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
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
        cell.numOfItemsView.layer.borderColor = UIColor(red:35/255.0, green:213/255.0, blue:185/255.0, alpha: 1.0).cgColor
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
