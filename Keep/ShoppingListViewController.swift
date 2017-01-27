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

typealias MailActionCallback = (_ cancelled: Bool, _ deleted: Bool, _ actionIndex: Int) -> Void

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let store = DataStore.sharedInstance
    
    @IBOutlet weak var tableView: UITableView!
    
    let list1 = shoppingList(title: "Weekly List", date: NSDate(), itemsRemaining: "3")
    let list2 = shoppingList(title: "Friday Dinner", date: NSDate(), itemsRemaining: "7")
    let list3 = shoppingList(title: "Cocktail Party", date: NSDate(), itemsRemaining: "100")
    let list4 = shoppingList(title: "Birthday Dinner", date: NSDate(), itemsRemaining: "27")
    let list5 = shoppingList(title: "Dinner", date: NSDate(), itemsRemaining: "13")
    let list6 = shoppingList(title: "Dinner", date: NSDate(), itemsRemaining: "1")
    let list7 = shoppingList(title: "Dinner", date: NSDate(), itemsRemaining: "1")
    let list8 = shoppingList(title: "Dinner", date: NSDate(), itemsRemaining: "1")
    
    var listTitlesTest = [shoppingList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        listTitlesTest = [list1, list2, list3, list4, list5, list6, list7, list8]

    }
    
    @IBAction func addListTapped(_ sender: Any) {
        
        //store.buttonStatus = "Create Event"
        performSegue(withIdentifier: "addList", sender: nil)
        
    }
    
    func titleForIndexPath(_ indexPath: IndexPath) -> String {
        return listTitlesTest[indexPath.row].title
    }
    
    func deleteList(_ indexPath:IndexPath) {
        listTitlesTest.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTitlesTest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "shoppingListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! ShoppingListCell
        
        cell.numOfItemsRemainingLabel.text = listTitlesTest[indexPath.row].itemsRemaining
        cell.shoppingListTitleLabel.text = listTitlesTest[indexPath.row].title
        cell.createdAtLabel.text = "Jan 16, 2017"

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
        cell.rightExpansion.buttonIndex = 1
        
        leftButton1.setPadding(38)
        leftButton2.setPadding(38)
        cell.leftButtons = [leftButton1, leftButton2]
        cell.leftExpansion.buttonIndex = 1
        return cell
        
    }
    
    func createAlert(withTitle:String) {
        
        let alert = UIAlertController(title: withTitle, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

}

class ShoppingListCell: MGSwipeTableCell {
    @IBOutlet weak var shoppingListTitleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var numOfItemsRemainingLabel: UILabel!
}

struct shoppingList {
    let title: String
    let date: NSDate
    let itemsRemaining: String
}
