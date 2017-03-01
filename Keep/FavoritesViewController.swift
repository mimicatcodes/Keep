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

class FavoritesViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let store = DataStore.sharedInstance
    var favItemToAddToStock: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        definesPresentationContext = true
        NotificationCenter.default.addObserver(forName: NotificationName.refreshFavorites, object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
//    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
//        return UIImage(named: "sample3")
//    }
    
    func configureSwipeButtons(cell:FavoriteCell, indexPath: IndexPath){
        let deleteButton = MGSwipeButton(title: EmptyString.none, icon: UIImage(named:ImageName.delete1), backgroundColor: Colors.salmon){ (sender: MGSwipeTableCell) -> Bool in
            self.delete(indexPath: indexPath)
            return true
        }

        cell.rightButtons = [deleteButton]
        cell.rightExpansion.buttonIndex = 0
    }
    
    func createAlert(withTitle:String) {
        let alert = UIAlertController(title: withTitle, message: EmptyString.none, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func moveToStock(indexPath: IndexPath){
        favItemToAddToStock = self.store.allFavoritedItems[indexPath.row].name
        performSegue(withIdentifier: Identifiers.Segue.favToStock, sender: self)
    }
    
    private func delete(indexPath: IndexPath){
        let realm = try! Realm()
        try! realm.write {
            let favItemToBeDeleted = self.store.allFavoritedItems[indexPath.row]
            for item in self.store.allItems {
                if item.name == favItemToBeDeleted.name {
                    item.isFavorited = false
                }
            }
            realm.delete(favItemToBeDeleted)
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.Segue.favToStock {
            let dest = segue.destination as! AddScannedItemVC
            if let item = favItemToAddToStock {
                dest.itemToAdd = item
            }
        }
    }
}

extension FavoritesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.allFavoritedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Cell.favoriteCell, for: indexPath) as! FavoriteCell
        cell.favoriteTitle.text = store.allFavoritedItems[indexPath.row].name
        cell.separatorInset = .zero
        cell.selectionStyle = .none
        configureSwipeButtons(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveToStock(indexPath: indexPath)
    }
}


