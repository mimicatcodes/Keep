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
import M13Checkbox
import NotificationCenter

class ShoppingListDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let store = DataStore.sharedInstance
    var name:String?
    var uniqueID: String = ""
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 100
        navigationItem.title = name
        NotificationCenter.default.addObserver(forName: REFRESH_ITEM_LIST_NOTIFICATION, object: nil, queue: nil) { (notification) in
            print("notification is \(notification)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }
    }
    
    
    @IBAction func addItemBtnTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "addItemToSL", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let predicate = NSPredicate(format: "list.uniqueID contains[c] %@", uniqueID)
        let filteredItems = store.allShoppingItems.filter(predicate)
        return filteredItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"listDetailCell", for: indexPath) as! ListDetailCell
        
        let predicate = NSPredicate(format: "list.uniqueID contains[c] %@", uniqueID)
        let filteredItems = store.allShoppingItems.filter(predicate)
        cell.titleLabel.text = filteredItems[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addItemToSL" {
            
            let dest = segue.destination as! AddItemVC
            dest.uniqueID = uniqueID
            
        }
    }
    
}



class ListDetailCell:UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var checkBox: M13Checkbox!
    
}


