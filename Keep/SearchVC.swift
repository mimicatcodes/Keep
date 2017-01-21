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
    
    var sampleData = bakery
    var filteredData = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredData.count
        }
        return sampleData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell?.textLabel?.text = self.filteredData[indexPath.row]
        } else {
            cell?.textLabel?.text = self.sampleData[indexPath.row]
        }
        
        return cell!
    }
    
    func filterContentForSearch(_ searchString: String){
        
        self.filteredData = self.sampleData.filter(){nil != $0.range(of: searchString)}
        self.tableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearch(searchController.searchBar.text!)
    }
    
}


