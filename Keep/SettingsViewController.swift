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

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let store = DataStore.sharedInstance
    let today = Date()
    
    var sections = ["My Account","Settings","Privacy Policy","Logout"]
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var secondTopView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var secondLeftView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var radarChartView: RadarChartView!

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
    
    // dummy data
    var categories:[String]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.separatorInset = .zero
        topView.underlinedBorder()
        secondTopView.underlinedBorder()
        midView.underlinedBorder()
        leftView.rightBorder()
        secondLeftView.rightBorder()
        setNumbers()
        
        // dummy data
        categories = ["Protein","Dairy","Vegetales","Fruits","Grains"]
        let numOfItemsInCategory = [10.0, 4.0, 6.0, 3.0, 8.0]
        
        setChart(dataPoints: categories, values: numOfItemsInCategory)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.setNumbers()
        }
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
    
    
    // Charts
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
        
        let font = UIFont(name: "Montserrat-Regular", size: 11)
        
        yAxis.drawLabelsEnabled = false
        xAxis.drawLabelsEnabled = true
        
        if let font = font {
            xAxis.labelFont = font
        }
        xAxis.labelTextColor = Colors.tealish
        
        radarChartView.sizeToFit()
        radarChartView.chartDescription?.text = ""

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
        let cell =  tableView.dequeueReusableCell(withIdentifier: Identifiers.Cell.accountCell, for: indexPath) as! AccountCell
        cell.title.text = sections[indexPath.row]
        
        return cell
    }
}

class AccountCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
}

@objc(RadarChartFormatter)
class ChartFormatter:NSObject,IAxisValueFormatter{
    
     let categories = ["Protein","Dairy","Vegetales","Fruits","Grains"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return categories[Int(value)]
    }
    
}
