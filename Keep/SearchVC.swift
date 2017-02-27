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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarView: UIView!
    
    let store = DataStore.sharedInstance
    var filteredItems:Results<Item>?
    var searchController: UISearchController!
    var textFieldInsideUISearchBar: UITextField!
    var textFieldInsideUISearchBarLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchControlloer()
        definesPresentationContext = true
        searchController.loadViewIfNeeded()
        searchFieldStyling()
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
        
        searchController.searchBar.textColor = Colors.warmGreyThree
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        searchController.searchBar.setBackgroundImage(UIImage(), for: .top, barMetrics: .default)
        searchBarView.underlinedBorder()
        
        tableView.tableFooterView = UIView()
        tableView.separatorInset = .zero
        tableView.backgroundView = UIView()
        
        searchBarView.addSubview(searchController.searchBar)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.frame.size.width = view.frame.size.width
    
    }
    
    func searchFieldStyling(){
        textFieldInsideUISearchBar = searchController.searchBar.value(forKey: Keys.searchField) as? UITextField
        textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: Keys.placeholderLabel) as? UILabel
        textFieldInsideUISearchBar?.font = UIFont(name: Fonts.montserratRegular, size: 15)
        textFieldInsideUISearchBarLabel?.textColor = Colors.tealishFaded
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
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
            if let item = filteredItems?[indexPath.row] {
                cell.titleLabel.text = item.name
                if item.isExpired {
                    cell.titleLabel.textColor = Colors.pastelRed
                } else {
                    cell.titleLabel.textColor = Colors.warmGreyThree
                }
                cell.quantityLabel.text = "x \(item.quantity)"
                cell.locationLabel.text = item.location
            }
        } else {
            cell.titleLabel.text = store.allItems[indexPath.row].name
            if store.allItems[indexPath.row].isExpired {
                cell.titleLabel.textColor = Colors.pastelRed
            } else {
                cell.titleLabel.textColor = Colors.warmGreyThree
            }
            cell.quantityLabel.text = "x \(store.allItems[indexPath.row].quantity)"
            cell.locationLabel.text = store.allItems[indexPath.row].location
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



