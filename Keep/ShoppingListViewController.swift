//
//  ShoppingListViewController.swift
//  Keep
//
//  Created by Luna An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let store = DataStore.sharedInstance
    
    @IBOutlet weak var tableView: UITableView!
    
    var listTitlesTest = ["Dinner","Birthday Dinner","Costco","CVS","Wing Dinner Treat","Things to Eat"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func addListTapped(_ sender: Any) {
        store.buttonStatus = "Create Event"
        performSegue(withIdentifier: "addList", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTitlesTest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as! ShoppingListCell
        cell.shoppingListTitleLabel.text = listTitlesTest[indexPath.row]
        return cell
    }
    
    // MARK: - Methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            print("********** The delete button is tapped ********** ")
            
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath
            
            //self.performSegue(withIdentifier: "addEvent", sender: nil)
            print("********** The delete button is tapped ********** ")
            
        }
        
        return [delete, edit]
    }

}

class ShoppingListCell: UITableViewCell {
    @IBOutlet weak var shoppingListTitleLabel: UILabel!
}
