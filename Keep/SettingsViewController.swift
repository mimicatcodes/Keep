//
//  SettingsViewController.swift
//  Keep
//
//  Created by Luna An on 1/3/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

// -TODO : Implement radar chart for metrics
class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let store = DataStore.sharedInstance
    let today = Date()
    
    var sections = ["My Account","Settings","Privacy Policy","Logout"]
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var secondTopView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var secondLeftView: UIView!
    @IBOutlet weak var midView: UIView!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var numOfItemsLabel: UILabel!
    @IBOutlet weak var numOfItemsBoughtThisWeekLabel: UILabel!
    @IBOutlet weak var numOfItemsExpiringLabel: UILabel!
    @IBOutlet weak var numOfItemsExpiredLabel: UILabel!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    
    var numOfItems: Int = 0
    var numOfItemsBoughtThisWeek: Int = 0
    var numOfExpiredItems: Int = 0
    var numOfExpiringItems: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.separatorInset = .zero
        topView.underlinedBorder()
        secondTopView.underlinedBorder()
        midView.underlinedBorder()
        leftView.rightBorder()
        secondLeftView.rightBorder()
        setNumbers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNumbers()
        print("View will appear called")
    }
    
    func setNumbers(){
        // 1st Section
        numOfItems = store.allItems.count
        if numOfItems < 2 {
             labelOne.text = "item in your stock"
        } else {
            labelOne.text = "items in your stock"
        }
        numOfItemsLabel.text = "\(numOfItems)"
        /*
        let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())
        let thisWeek = Calendar.current.date(byAdding: .weekOfYear, value: 0, to: Date())
        let nextWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())
         let fallsBetween = (startDate...endDate).contains(Date())
 */
        // 2nd Section
        if numOfItemsBoughtThisWeek < 2 {
            labelTwo.text = "item bought this week"
        } else {
            labelTwo.text = "items bought this week"
        }
        numOfItemsBoughtThisWeekLabel.text = "\(numOfItemsBoughtThisWeek)"
        
        // 3rd Section
        numOfExpiringItems = store.allItems.filter("isExpiring == true AND isExpired == false").count
        if numOfExpiringItems < 2 {
            labelThree.text = "item expiring"
        } else {
            labelThree.text = "items expiring"
        }
        numOfItemsExpiringLabel.text = "\(numOfExpiringItems)"
        
        // 4th Section
        numOfExpiredItems = store.allItems.filter("isExpired == true").count
        if numOfExpiredItems < 2 {
            labelFour.text = "item expired"
        } else {
            labelFour.text = "items expired"
        }
        numOfItemsExpiredLabel.text = "\(numOfExpiredItems)"
    }
    
    
    func daysBetweenTwoDates(start: Date, end: Date) -> Int{
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else { return 0 }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else { return 0 }
        return end - start
    
    }
    
    // TV Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountCell
        cell.title.text = sections[indexPath.row]
        
        return cell
    }
}

class AccountCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
}
