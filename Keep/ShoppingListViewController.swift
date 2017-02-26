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
    
    @IBOutlet weak var tableView: UITableView!
    
    let store = DataStore.sharedInstance
    var uniqueID: String = ""
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
    
    func deleteList(_ indexPath:IndexPath) {
        
        //store.shoppingLists?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func configureSwipeButtons(cell:ShoppingListCell){
        let rightButton1 = MGSwipeButton(title: "", icon: UIImage(named:"Delete2"), backgroundColor: Colors.salmon) { (sender: MGSwipeTableCell) -> Bool in
            self.createAlert(withTitle: "Delete")
            return true
        }
        
        let rightButton2 = MGSwipeButton(title: "", icon: UIImage(named:"EditGrey2"), backgroundColor: Colors.pinkishGrey)  { (sender: MGSwipeTableCell) -> Bool in
            self.shareList()
            return true
        }
        
        let leftButton1 = MGSwipeButton(title: "Left1", backgroundColor: UIColor.red) { (sender: MGSwipeTableCell) -> Bool in
            self.createAlert(withTitle: "Left1")
            return true
        }
        
        let leftButton2 = MGSwipeButton(title: "Left2", backgroundColor: UIColor.yellow) { (sender: MGSwipeTableCell) -> Bool in
            self.createAlert(withTitle: "Left2")
            return true
        }

        cell.rightButtons = [rightButton1, rightButton2]
        cell.rightExpansion.buttonIndex = 0
    
        cell.leftButtons = [leftButton1, leftButton2]
        cell.leftExpansion.buttonIndex = 1
    }
    
    func formatDates() {
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd, yyyy"
    }
    
    func shareList(){
        let predicate = NSPredicate(format: "list.uniqueID contains[c] %@", uniqueID)
        let filteredItems = store.allShoppingItems.filter(predicate)
        var emptyArray = String()
        
        for item in filteredItems {
            emptyArray.append(item.name)
        }
        
        let activityController = UIActivityViewController(activityItems: [emptyArray], applicationActivities: nil)
        
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityController, animated: true, completion: nil)
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
                let selectedTitle = store.allShopingLists[index]
                let dest = segue.destination as! ShoppingListDetailVC
                dest.name = selectedTitle.title
                dest.uniqueID = selectedTitle.uniqueID
                print(selectedTitle.uniqueID)
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
        configureSwipeButtons(cell: cell)
        return cell
    }
}
