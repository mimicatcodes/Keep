//
//  Helper.swift
//  Keep
//
//  Created by Luna An on 2/28/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import Foundation
import UserNotifications

class Helper {
    
    static func formatDates(formatter: DateFormatter){
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = DateFormat.monthDayYear
    }
    
    static func daysBetweenTwoDates(start: Date, end: Date) -> Int{
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else { return 0 }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else { return 0 }
        return end - start
    }
    
    static func setUpNotification(hour:Int, minute:Int){
        
        let store = DataStore.sharedInstance
        
        var itemsExpiringToday:[Item] = []
        for item in store.allItems {
            if daysBetweenTwoDates(start: Date(), end: item.exp) == 0 {
                itemsExpiringToday.append(item)
            }
        }
        
        if itemsExpiringToday.count > 0 {
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            
            let content = UNMutableNotificationContent()
            
            if itemsExpiringToday.count == 1 {
                content.title = LocalNotification.title
                content.subtitle = "\(itemsExpiringToday.count)" + LocalNotification.subtitleSingular
                content.body = LocalNotification.bodySingular
                content.categoryIdentifier = LocalNotification.categoryIdentifier
                //content.userInfo = ["": ""]
                content.sound = .default()
            } else {
                content.title = LocalNotification.title
                content.subtitle = "\(itemsExpiringToday.count)" + LocalNotification.subtitlePlural
                content.body = LocalNotification.bodyPlular
                content.categoryIdentifier = LocalNotification.categoryIdentifier
                //content.userInfo = ["": ""]
                content.sound = .default()
            }
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            
        } else {
            print(LocalNotification.messageforNoNeed)
        }
    }
}

