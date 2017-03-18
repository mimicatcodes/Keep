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
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var rightTopView: UIView!
    @IBOutlet weak var rightMidView: UIView!
    @IBOutlet weak var rightBottomView: UIView!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var radarChartView: RadarChartView!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var numOfItemsLabel: UILabel!
    @IBOutlet weak var numOfItemsExpiringTodayLabel: UILabel!
    @IBOutlet weak var numOfItemsExpiringLabel: UILabel!
    @IBOutlet weak var numOfItemsExpiredLabel: UILabel!
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    
    let store = DataStore.sharedInstance
    var sections:[SettingMenu] = [.reminder, .sendFeedback, .rateUs]
    var numOfItems: Int = 0
    var numOfItemsExpiringToday: Int = 0
    var numOfExpiredItems: Int = 0
    var numOfExpiringItems: Int = 0
    let mailComposerVC = MFMailComposeViewController()
    var numOfItemsInCategory:[Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = .zero
        setData()
        addGestureRecognizer()
        DispatchQueue.main.async {
            self.setNumbers()

        }
        setChart(dataPoints: FoodGroups.categories, values: self.numOfItemsInCategory)
        NotificationCenter.default.addObserver(forName: NotificationName.refreshCharts, object: nil, queue: nil) { notification in
            self.setChart(dataPoints: FoodGroups.categories, values: self.numOfItemsInCategory)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setData()
        setChart(dataPoints: FoodGroups.categories, values: self.numOfItemsInCategory)
        DispatchQueue.main.async {
            self.setNumbers()
        }
    }
    
    func addGestureRecognizer(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let gestureRecognizerTwo = UITapGestureRecognizer(target: self, action: #selector(handleTapTwo))
        let gestureRecognizerThree = UITapGestureRecognizer(target: self, action: #selector(handleTapThree))
        gestureRecognizer.delegate = self
        rightTopView.addGestureRecognizer(gestureRecognizer)
        rightMidView.addGestureRecognizer(gestureRecognizerTwo)
        rightBottomView.addGestureRecognizer(gestureRecognizerThree)
    }
    
    func handleTap(gestureRecognizer: UIGestureRecognizer) {
        store.settingExpire = SettingExpire.threeDays.rawValue
        performSegue(withIdentifier: Identifiers.Segue.showExpires, sender: self)
    }
    
    func handleTapTwo(gestureRecognizer: UIGestureRecognizer) {
        store.settingExpire = SettingExpire.today.rawValue
        performSegue(withIdentifier: Identifiers.Segue.showExpires, sender: self)
    }
    
    func handleTapThree(gestureRecognizer: UIGestureRecognizer) {
        store.settingExpire = SettingExpire.expired.rawValue
        performSegue(withIdentifier: Identifiers.Segue.showExpires, sender: self)
    }
    
    func setNumbers(){
        // 1st Section - all
        numOfItems = store.allItems.count
        if numOfItems < 2 {
             labelOne.text = Labels.singular
        } else {
            labelOne.text = Labels.plural
        }
        numOfItemsLabel.text = "\(numOfItems)"
        
        // 2nd Section - 3 days
        numOfExpiringItems = store.itemsExpiring.count
        if numOfExpiringItems < 2 {
            labelTwo.text = Labels.signularExpiring
        } else {
            labelTwo.text = Labels.pluralExpiring
        }
        numOfItemsExpiringLabel.text = "\(numOfExpiringItems)"
        
        // 3rd Section - today
        numOfItemsExpiringToday = store.itemsExpiringToday.count
        if numOfItemsExpiringToday < 2 {
            labelThree.text = Labels.signularExpiring
        } else {
            labelThree.text = Labels.pluralExpiring
        }
        numOfItemsExpiringTodayLabel.text = "\(numOfItemsExpiringToday)"
    
        // 4th Section - expired
        numOfExpiredItems = store.itemsExpired.count
        if numOfExpiredItems < 2 {
            labelFour.text = Labels.itemIs
        } else {
            labelFour.text = Labels.ItemsAre
        }
        numOfItemsExpiredLabel.text = "\(numOfExpiredItems)"
    }
    
    func sendFeedback() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([Email.address])
            mail.setSubject(Email.subject)
            mail.setMessageBody(EmptyString.none, isHTML: true)
            mail.navigationBar.tintColor = Colors.brownishGreyTwo
            present(mail, animated: true)
        } else {
            print(Email.failedMessage)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : AppID.ituensAddress + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    func setData(){
        let itemsInVegetables = Double(store.allItems.filter(Filters.vegetables).count)
        print(store.allItems.filter(Filters.vegetables))
        
        let itemsInFruits = Double(store.allItems.filter(Filters.fruits).count)
        print(store.allItems.filter(Filters.fruits))
        
        let itemsInPasta = Double(store.allItems.filter(Filters.grainsPasta).count)
        let itemsInOtherGrains = Double(store.allItems.filter(Filters.grainsOther).count)
        
        let itemsInDairy = Double(store.allItems.filter(Filters.dairy).count)
        
        let itemsInMeats = Double(store.allItems.filter(Filters.proteinMeats).count)
        print(store.allItems.filter(Filters.proteinMeats))
        let itemsInBeans = Double(store.allItems.filter(Filters.proteinBeans).count)
        print(store.allItems.filter(Filters.proteinBeans))
        let itemsInNuts =  Double(store.allItems.filter(Filters.proteinNuts).count)
        numOfItemsInCategory = [itemsInVegetables, itemsInFruits, itemsInPasta + itemsInOtherGrains, itemsInDairy, itemsInMeats + itemsInBeans + itemsInNuts]
    }
}

// Charts API
extension SettingsViewController {
    func setChart(dataPoints: [String], values: [Double]) {
    
        radarChartView.noDataText = "No chart data available."
       
        let chartFormatter = ChartFormatter()
        let yAxis = radarChartView.yAxis
        let xAxis = radarChartView.xAxis
        
        var dataEntries: [RadarChartDataEntry] = []
        for i in 0..<values.count {
            let dataEntry = RadarChartDataEntry(value: values[i])
            xAxis.valueFormatter = chartFormatter
            radarChartView.xAxis.valueFormatter=xAxis.valueFormatter
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = RadarChartDataSet(values: dataEntries, label: nil)
        chartDataSet.drawFilledEnabled = true
        chartDataSet.drawValuesEnabled = false
        chartDataSet.fillColor = Colors.tealish
        
        let chartData = RadarChartData(dataSet: chartDataSet)
        chartData.labels = dataPoints
        radarChartView.data = chartData
        
        let font = UIFont(name: Fonts.montserratRegular, size: 11)
        
        yAxis.drawLabelsEnabled = false
        xAxis.drawLabelsEnabled = true
        
        if let font = font {
            xAxis.labelFont = font
        }
        xAxis.labelTextColor = Colors.tealish
        
        radarChartView.sizeToFit()
        radarChartView.chartDescription?.text = EmptyString.none
        radarChartView.legend.enabled = false
    }
}

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: Identifiers.Cell.accountCell, for: indexPath) as! AccountCell
        cell.title.text = sections[indexPath.row].rawValue
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: Identifiers.Segue.setReminder, sender: self)
        } else if indexPath.row == 1 {
            sendFeedback()
        } else {
            rateApp(appId: AppID.appID, completion: { (success) in
                print("RateApp \(success)")
            })
        }
    }
}

@objc(RadarChartFormatter)
class ChartFormatter:NSObject,IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return FoodGroups.categories[Int(value)]
    }
}
