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

class ShoppingListDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let store = DataStore.sharedInstance
    var name:String?
    var uniqueID: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.allowsMultipleSelection = true
        tableView.rowHeight = 100
        navigationItem.title = name
        definesPresentationContext = true
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
        cell.separatorInset = .zero
        
        if filteredItems[indexPath.row].isPurchased == true {
            cell.titleLabel.textColor = MAIN_BORDER_COLOR
            cell.checkBoxImgView.image = #imageLiteral(resourceName: "ChecklistActive2")
            cell.moveButton.isHidden = false
    
        } else {
            cell.titleLabel.textColor = UIColor(red: 77/255.0, green: 77/255.0, blue: 77/255.0, alpha: 1)
            cell.checkBoxImgView.image = #imageLiteral(resourceName: "ChecklistBase2")
            cell.moveButton.isHidden = true

        }
        
        cell.moveButton.tag = indexPath.row
        cell.moveButton.addTarget(self, action: #selector(buttonActions), for: .touchUpInside)
        
        cell.tapAction = { cell in
            
            let name = tableView.indexPath(for: cell)?.row
            
            print(name ?? "Error")
        }
        
        return cell

    }
    
    func buttonActions(sender:UIButton){

        let predicate = NSPredicate(format: "list.uniqueID contains[c] %@", uniqueID)
        let filteredItems = store.allShoppingItems.filter(predicate)
        let titleString = filteredItems[sender.tag].name
        print("----titleString is : --- \(titleString)")
        
        store.tappedSLItemToSendToLocation = titleString

        /*
        let firstActivityItem = "\(titleString)"
        
        let activityController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityController, animated: true, completion: nil)
 */

    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("Cell sected at \(indexPath.row)")
    
        let predicate = NSPredicate(format: "list.uniqueID contains[c] %@", uniqueID)
        let filteredItems = store.allShoppingItems.filter(predicate)
        
        let realm = try! Realm()
        try! realm.write {
            
            if filteredItems[indexPath.row].isPurchased == false {
                filteredItems[indexPath.row].isPurchased = true

            } else {
                filteredItems[indexPath.row].isPurchased = false
            }
            
        }

        print(filteredItems[indexPath.row].isPurchased)
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addItemToSL" {
            
            let dest = segue.destination as! AddItemVC
            dest.uniqueID = uniqueID
            
        }
    }
    
}

class ListDetailCell:UITableViewCell {
    
    
    var tapAction: ((UITableViewCell) -> Void)?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBoxImgView: UIImageView!
    @IBOutlet weak var moveButton: UIButton!
    @IBAction func moveButtonTapped(_ sender: UIButton) {
        tapAction?(self)
    }
    
}


