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

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let store = DataStore.sharedInstance

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        definesPresentationContext = true
        tableView.separatorColor = UIColor(red:219/255.0, green:219/255.0, blue:219/255.0, alpha: 1.0)
        NotificationCenter.default.addObserver(forName: REFRESH_TV_NOTIFICATION, object: nil, queue: nil) { notification in
            print("notification is \(notification)")
            self.tableView.reloadData()
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func addListTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "addList", sender: nil)
        
    }
    
    func titleForIndexPath(_ indexPath: IndexPath) -> String {
       
        return store.allShopingLists[indexPath.row].title
    }
    
    func deleteList(_ indexPath:IndexPath) {
        
        //store.shoppingLists?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return store.allShopingLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "shoppingListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! ShoppingListCell
        
        cell.numOfItemsView.layer.borderWidth = 1.2
        cell.numOfItemsView.layer.borderColor = UIColor(red:35/255.0, green:213/255.0, blue:185/255.0, alpha: 1.0).cgColor
        cell.numOfItemsView.backgroundColor = UIColor.clear
        // make rgb color extensions when refactoring

        cell.numOfItemsRemainingLabel.text = String(describing: store.allShopingLists[indexPath.row].numOfItems)
        cell.shoppingListTitleLabel.text = store.allShopingLists[indexPath.row].title.capitalized
        cell.createdAtLabel.text = store.allShopingLists[indexPath.row].isCreatedAt
        cell.selectionStyle = .none
        cell.separatorInset = .zero
        configureSwipeButtons(cell: cell)
        
        return cell
        
    }
    
    func configureSwipeButtons(cell:ShoppingListCell){
        
        let rightButton1 = MGSwipeButton(title: "Delete", backgroundColor: UIColor.red) { (sender: MGSwipeTableCell) -> Bool in
            self.createAlert(withTitle: "Delete")
            return true
        }
        
        let rightButton2 = MGSwipeButton(title: "Edit", backgroundColor: UIColor.green) { (sender: MGSwipeTableCell) -> Bool in
            self.createAlert(withTitle: "Edit")
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
        
        rightButton1.setPadding(38)
        rightButton2.setPadding(38)
        cell.rightButtons = [rightButton1, rightButton2]
        cell.rightExpansion.buttonIndex = 0
        
        leftButton1.setPadding(38)
        leftButton2.setPadding(38)
        cell.leftButtons = [leftButton1, leftButton2]
        cell.leftExpansion.buttonIndex = 1

    }
    
    func createAlert(withTitle:String) {
        
        let alert = UIAlertController(title: withTitle, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItems" {
            if let index = tableView.indexPathForSelectedRow?.row {
                let selectedTitle = store.allShopingLists[index]
                let dest = segue.destination as! ShoppingListDetailVC
                dest.name = selectedTitle.title
                dest.uniqueID = selectedTitle.uniqueID
                print(selectedTitle.uniqueID)
            }
        }
    }

}

class ShoppingListCell: MGSwipeTableCell {
    
    @IBOutlet weak var numOfItemsView: UIView!
    @IBOutlet weak var shoppingListTitleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var numOfItemsRemainingLabel: UILabel!
    
}


