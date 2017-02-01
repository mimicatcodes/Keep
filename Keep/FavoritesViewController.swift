//
//  FavoritesViewController.swift
//  Keep
//
//  Created by Luna An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

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
        
        return 50
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.allFavoritedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteCell
        cell.favoriteTitle.text = store.allFavoritedItems[indexPath.row].name
        cell.separatorInset = .zero
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let realm = try! Realm()
            try! realm.write {
                let favItemToBeDeleted = self.store.allFavoritedItems[indexPath.row]
                print("\(favItemToBeDeleted) has been deleted")
                realm.delete(favItemToBeDeleted)
                
            }
            self.tableView.reloadData()
            print("Deleted an item from favoritedItems")
            
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath
            
            print("EDIT Tapped")
            
        }
        
        return [delete, edit]
    }

    
}

class FavoriteCell:UITableViewCell {
    
    @IBOutlet weak var favoriteTitle: UILabel!
}
