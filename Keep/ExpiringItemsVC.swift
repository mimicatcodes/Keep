//
//  ExpiringItemsVC.swift
//  Keep
//
//  Created by Luna An on 3/9/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

class ExpiringItemsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let store = DataStore.sharedInstance
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.formatDates(formatter: formatter)
        tableView.separatorInset = .zero
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureNavTitle()
    }
    
    @IBAction func backToSetting(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func configureNavTitle(){
        switch store.settingExpire {
        case SettingExpire.threeDays.rawValue:
            navigationBar.topItem?.title = Labels.expiringInThreeDays
        case SettingExpire.today.rawValue:
            navigationBar.topItem?.title = Labels.expiringTodayCap
        case SettingExpire.expired.rawValue:
            navigationBar.topItem?.title = Labels.expiredItems
        default:
            navigationBar.topItem?.title = Labels.expiringItems
        }
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = emptyState.expiringItems
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch store.settingExpire {
        case SettingExpire.threeDays.rawValue:
            return store.itemsExpiring.count
        case SettingExpire.today.rawValue:
            return store.itemsExpiringToday.count
        case SettingExpire.expired.rawValue:
            return store.itemsExpired.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Cell.settingExpiresCell, for: indexPath) as! SettingExpiresCell
        
        switch store.settingExpire {
        case SettingExpire.threeDays.rawValue:
            cell.nameLabel.text = store.itemsExpiring[indexPath.row].name
            cell.locationLabel.text = store.itemsExpiring[indexPath.row].location
            cell.quantityLabel.text = Labels.xQuantity + store.itemsExpiring[indexPath.row].quantity
            cell.expireLabel.text = Labels.expiredOn + formatter.string(from: store.itemsExpiring[indexPath.row].exp )
        case SettingExpire.today.rawValue:
            cell.nameLabel.text = store.itemsExpiringToday[indexPath.row].name
            cell.locationLabel.text = store.itemsExpiringToday[indexPath.row].location
            cell.quantityLabel.text = Labels.xQuantity + store.itemsExpiringToday[indexPath.row].quantity
            cell.expireLabel.text = Labels.expiredOn + formatter.string(from: store.itemsExpiringToday[indexPath.row].exp )
        case SettingExpire.expired.rawValue:
            cell.nameLabel.text = store.itemsExpired[indexPath.row].name
            cell.locationLabel.text = store.itemsExpired[indexPath.row].location
            cell.quantityLabel.text = Labels.xQuantity + store.itemsExpired[indexPath.row].quantity
            cell.expireLabel.text = Labels.expired
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

