//
//  FavoritesViewController.swift
//  Keep
//
//  Created by Luna An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift
import MGSwipeTableCell

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let store = DataStore.sharedInstance

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        definesPresentationContext = true
        NotificationCenter.default.addObserver(forName: REFRESH_FAVORITES, object: nil, queue: nil) { (notification) in
            print("notification is \(notification)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.allFavoritedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteCell
        cell.favoriteTitle.text = store.allFavoritedItems[indexPath.row].name
        cell.separatorInset = .zero
        cell.selectionStyle = .none
        configureSwipeButtons(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureSwipeButtons(cell:FavoriteCell, indexPath: IndexPath){
        
        let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: UIColor.red) { (sender: MGSwipeTableCell) -> Bool in
            self.delete(indexPath: indexPath)
            return true
        }
        
        let moveToStockBtn = MGSwipeButton(title: "Stock", backgroundColor: UIColor.red) { (sender: MGSwipeTableCell) -> Bool in
            self.createAlert(withTitle: "Left1")
            return true
        }
        
        let moveToSLBtn = MGSwipeButton(title: "SL", backgroundColor: UIColor.yellow) { (sender: MGSwipeTableCell) -> Bool in
            self.createAlert(withTitle: "Left2")
            return true
        }
        
        deleteButton.setPadding(30)
        cell.rightButtons = [deleteButton]
        cell.rightExpansion.buttonIndex = 0
        
        moveToStockBtn.setPadding(30)
        moveToSLBtn.setPadding(30)
        cell.leftButtons = [moveToStockBtn, moveToSLBtn]
        cell.leftExpansion.buttonIndex = 1
        
    }
    
    func createAlert(withTitle:String) {
        
        let alert = UIAlertController(title: withTitle, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func moveToStock(){
        
    }
    
    private func moveToSL(){
        
    }
    
    
    private func delete(indexPath: IndexPath){
        
        let realm = try! Realm()
        try! realm.write {
            let favItemToBeDeleted = self.store.allFavoritedItems[indexPath.row]
            for item in self.store.allItems {
                if item.name == favItemToBeDeleted.name {
                    item.isFavorited = false
                    print(item)
                    print(item.isFavorited)
                }
            }
            print("\(favItemToBeDeleted) has been deleted")
            realm.delete(favItemToBeDeleted)
            
        }
        self.tableView.reloadData()
        print("Deleted an item from favoritedItems")
    }
    
}

class FavoriteCell:MGSwipeTableCell {
    
    @IBOutlet weak var favoriteTitle: UILabel!
}
