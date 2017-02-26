//
//  SearchVC.swift
//  Keep
//
//  Created by Luna An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    // TODO: Fix search
    // TODO: include info - location, quantity
    // TODO: Navigation - fix it
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBarView: UIView!
    let store = DataStore.sharedInstance
    var filteredItems:Results<Item>?
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchControlloer()
        definesPresentationContext = true
        searchController.loadViewIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func configureSearchControlloer(){
    
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .blue
        searchController.searchBar.layer.borderColor = Colors.tealishFaded.cgColor
        
        let attributes = [
            NSForegroundColorAttributeName : Colors.tealish,
            NSFontAttributeName : UIFont(name: Fonts.montserratRegular, size: 15),
        ]
        searchController.searchBar.setImage(UIImage(named: "Clear"), for: .clear, state: .normal)
        
        searchController.searchBar.textColor = Colors.tealish
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        searchController.searchBar.setBackgroundImage(UIImage(), for: .top, barMetrics: .default)
        searchBarView.underlinedBorder()
        //searchController.searchBar.layer.borderWidth = 1.0
        
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.backgroundView = UIView()
   
        
        /*tableView.layer.masksToBounds = true
        tableView.layer.borderColor = Colors.tealishFaded.cgColor
        tableView.layer.borderWidth = 1.0*/

       
        // Add the search bar as a subview of the UIView you added above the table view
        searchBarView.addSubview(searchController.searchBar)        // Call sizeToFit() on the search bar so it fits nicely in the UIView
        searchController.searchBar.sizeToFit()
        // For some reason, the search bar will extend outside the view to the left after calling sizeToFit. This next line corrects this.
        searchController.searchBar.frame.size.width = view.frame.size.width
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            if let items = self.filteredItems {
                return items.count
            }
        }
        return store.allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.titleLabel?.text = filteredItems?[indexPath.row].name
        } else {
            cell.titleLabel?.text = store.allItems[indexPath.row].name
        }
        return cell
    }
    
    func filterContentForSearch(_ searchString: String) {
        
        let predicate = NSPredicate(format: "name contains[c] %@", searchString)
        filteredItems = store.allItems.filter(predicate)
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchString = searchController.searchBar.text {
            filterContentForSearch(searchString)
        }
    }
}



