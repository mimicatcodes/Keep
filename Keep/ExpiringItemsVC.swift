//
//  ExpiringItemsVC.swift
//  Keep
//
//  Created by Luna An on 3/9/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit

class ExpiringItemsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let store = DataStore.sharedInstance
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.formatDates(formatter: formatter)
    }
    @IBAction func backToSetting(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch store.settingExpire {
        case SettingExpire.threeDays.rawValue:
            return store.allItems.filter(Filters.isExpiring).count
        case SettingExpire.today.rawValue:
            return store.allItems.filter(Filters.isExpiringToday).count
        case SettingExpire.expired.rawValue:
            return store.allItems.filter(Filters.isExpired).count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.Cell.settingExpiresCell, for: indexPath) as! SettingExpiresCell
        
        
        // SORT!  + UI + Condition for items expiring today
        
        switch store.settingExpire {
        case SettingExpire.threeDays.rawValue:
            cell.nameLabel.text = store.allItems.filter(Filters.isExpiring)[indexPath.row].name
            cell.locationLabel.text = store.allItems.filter(Filters.isExpiring)[indexPath.row].location
            cell.quantityLabel.text = store.allItems.filter(Filters.isExpiring)[indexPath.row].quantity
            cell.expireLabel.text = "Expires on " + formatter.string(from: store.allItems.filter(Filters.isExpiring)[indexPath.row].exp )
        case SettingExpire.today.rawValue:
            cell.nameLabel.text = store.allItems.filter(Filters.isExpiringToday)[indexPath.row].name
            cell.locationLabel.text = store.allItems.filter(Filters.isExpiringToday)[indexPath.row].location
            cell.quantityLabel.text = store.allItems.filter(Filters.isExpiringToday)[indexPath.row].quantity
            cell.expireLabel.text = "Expires on " + formatter.string(from: store.allItems.filter(Filters.isExpiringToday)[indexPath.row].exp )
        case SettingExpire.expired.rawValue:
            cell.nameLabel.text = store.allItems.filter(Filters.isExpired)[indexPath.row].name
            cell.locationLabel.text = store.allItems.filter(Filters.isExpired)[indexPath.row].location
            cell.quantityLabel.text = store.allItems.filter(Filters.isExpired)[indexPath.row].quantity
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

