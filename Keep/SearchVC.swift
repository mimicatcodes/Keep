//
//  SearchVC.swift
//  Keep
//
//  Created by Luna An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class SearchVC: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    // TODO: Fix search 
    // TODO: include info - location, quantity 
    // TODO: Navigation - fix it
    
    let store = DataStore.sharedInstance
    var filteredItems:Results<Item>?
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            if let items = self.filteredItems {
                return items.count
            }
        }
        return store.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell?.textLabel?.text = self.filteredItems?[indexPath.row].name
        } else {
            cell?.textLabel?.text = self.store.allItems[indexPath.row].name
        }
        return cell!
    }
    
    func filterContentForSearch(_ searchString: String) {
        let allItems = store.allItems
        let predicate = NSPredicate(format: "name contains[c] %@", searchString)
        self.filteredItems = allItems.filter(predicate)
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearch(searchController.searchBar.text!)
    }
}


