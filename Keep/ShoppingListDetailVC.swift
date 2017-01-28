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
    var uniqueID: String?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 100
        //tableView.allowsMultipleSelection = true
        navigationItem.title = name
        print(uniqueID!)
        NotificationCenter.default.addObserver(forName: REFRESH_ITEM_LIST_NOTIFICATION, object: nil, queue: nil) { (notification) in
            print("notification is \(notification)")
            self.tableView.reloadData()
            
        }
    }
    
    
    @IBAction func addItemBtnTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "addItemToSL", sender: nil)
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            store.listID = store.allShopingLists[indexPath.row].uniqueID
        }
        

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let id = uniqueID {
            
            let predicate = NSPredicate(format: "list.uniqueID contains[c] %@", id)
            print("--------")
            let filteredItems = store.allShoppingItems.filter(predicate)
            
            return filteredItems.count
    

        }
        return store.allShoppingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"listDetailCell", for: indexPath) as! ListDetailCell
        
        if let id = uniqueID {
            
            let predicate = NSPredicate(format: "list.uniqueID contains[c] %@", id)
            print("--------")
            let filteredItems = store.allShoppingItems.filter(predicate)
            cell.titleLabel.text = filteredItems[indexPath.row].name
            
            // post to notification center
            
            
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "addItemToSL" {
            if let id = uniqueID {
                print(id)
                let dest = segue.destination as! AddItemVC
                dest.uniqueID = id
                
            }
            /*
                let listTitleSelected = navigationItem.title
                let dest = segue.destination as! AddItemVC
                dest.listTitle = listTitleSelected
             
             
                */
            
        }
    }
    
}



class ListDetailCell:UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var checkBox: M13Checkbox!
    
}


