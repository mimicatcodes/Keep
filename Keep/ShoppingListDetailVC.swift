//
//  ShoppingListDetailVC.swift
//  Keep
//
//  Created by Luna An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import QuartzCore
import MGSwipeTableCell
import M13Checkbox

class ShoppingListDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var toDoItems = [ToDoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 100;
        //tableView.allowsMultipleSelection = true
        
        toDoItems.append(ToDoItem(title: "Apple"))
        toDoItems.append(ToDoItem(title: "Milk"))
        toDoItems.append(ToDoItem(title: "Blue Cheese"))
        toDoItems.append(ToDoItem(title: "Bread"))
        toDoItems.append(ToDoItem(title: "Bagels"))
        toDoItems.append(ToDoItem(title: "Basil Pesto"))
        toDoItems.append(ToDoItem(title: "Pasta"))
        toDoItems.append(ToDoItem(title: "Musseles"))
        toDoItems.append(ToDoItem(title: "Strawberry Jam"))
        toDoItems.append(ToDoItem(title: "Toilet Paper"))
        toDoItems.append(ToDoItem(title: "Chicken"))
        toDoItems.append(ToDoItem(title: "Beef"))
    }
    
//    @IBAction func addItemBtnTapped(_ sender: Any) {
//        
//        performSegue(withIdentifier: "addItem", sender: nil)
//    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"listDetailCell", for: indexPath) as! ListDetailCell
        
        //cell.selectionStyle = .none
        cell.titleLabel.text = toDoItems[indexPath.row].title
        
        return cell
    }
        
}



class ListDetailCell:UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var checkBox: M13Checkbox!
    
}


