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

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let store = DataStore.sharedInstance
    let today = Date()
    
    var sections = ["Set Time for Reminder", "Send Feedback"]
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var rightTopView: UIView!
    @IBOutlet weak var rightMidView: UIView!
    @IBOutlet weak var rightBottomView: UIView!
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var radarChartView: RadarChartView!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var numOfItemsLabel: UILabel!
    @IBOutlet weak var numOfItemsExpiringThisWeekLabel: UILabel!
    @IBOutlet weak var numOfItemsExpiringLabel: UILabel!
    @IBOutlet weak var numOfItemsExpiredLabel: UILabel!
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelFour: UILabel!
    
    var numOfItems: Int = 0
    var numOfItemsExpiringThisWeek: Int = 0
    var numOfExpiredItems: Int = 0
    var numOfExpiringItems: Int = 0
    // dummy data
    var categories:[String]!
    
    let mailComposerVC = MFMailComposeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = .zero
        //topView.underlinedBorder()
        midView.underlinedBorder()
        setNumbers()
        
        // dummy data
        categories = ["Protein","Dairy","Vegetales","Fruits","Grains"]
        let numOfItemsInCategory = [10.0, 4.0, 6.0, 3.0, 8.0]
        
        setChart(dataPoints: categories, values: numOfItemsInCategory)
        radarChartView.legend.enabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.setNumbers()
        }
    }
    
    
    func setNumbers(){
        // 1st Section
        numOfItems = store.allItems.count
        if numOfItems < 2 {
             labelOne.text = Labels.singular
        } else {
            labelOne.text = Labels.plural
        }
        numOfItemsLabel.text = "\(numOfItems)"
        
        // 2nd Section
        numOfItemsExpiringThisWeek = store.allItems.filter(Filters.isExpiringInAWeek).count
        if numOfItemsExpiringThisWeek < 2 {
            labelTwo.text = Labels.signularExpiring
        } else {
            labelTwo.text = Labels.pluralExpiring
        }
        numOfItemsExpiringThisWeekLabel.text = "\(numOfItemsExpiringThisWeek)"
        
        // 3rd Section
        numOfExpiringItems = store.allItems.filter(Filters.isExpiring).count
        if numOfExpiringItems < 2 {
            labelThree.text = Labels.signularExpiring
        } else {
            labelThree.text = Labels.pluralExpiring
        }
        numOfItemsExpiringLabel.text = "\(numOfExpiringItems)"
        
        // 4th Section
        numOfExpiredItems = store.allItems.filter(Filters.isExpired).count
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
            mail.setToRecipients(["getkeep@gmail.com"])
            mail.setSubject("Hi Keep Team!")
            mail.setMessageBody("", isHTML: true)
            
            mail.navigationBar.tintColor = UIColor.white
            present(mail, animated: true)
        } else {
            print("Unable to send an email")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}

// Charts API
extension SettingsViewController {
    func setChart(dataPoints: [String], values: [Double]) {
        radarChartView.noDataText = "No chart data available yet. Please add items in your inventory"
        
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
    }
}

extension SettingsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: Identifiers.Cell.accountCell, for: indexPath) as! AccountCell
        cell.title.text = sections[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: Identifiers.Segue.setReminder, sender: self)
        } else {
            sendFeedback()
        }
    }
}

@objc(RadarChartFormatter)
class ChartFormatter:NSObject,IAxisValueFormatter{
    
     let categories = ["Protein","Dairy","Vegetales","Fruits","Grains"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return categories[Int(value)]
    }
    
}
