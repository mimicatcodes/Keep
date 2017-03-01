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
    static func daysBetweenTwoDates(start: Date, end: Date) -> Int{
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else { return 0 }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else { return 0 }
        
        return end - start
    }
    
    static func setLocalNotification(date: Date) {
        let store = DataStore.sharedInstance
        var itemsExpiringToday:[Item] = []
        for item in store.allItems {
            if daysBetweenTwoDates(start: Date(), end: item.exp) == 0 {
                itemsExpiringToday.append(item)
            }
        }
        
        if itemsExpiringToday.count > 0 {
            
            let calendar = Calendar.current
            let components = calendar.dateComponents( [.hour, .minute], from:date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
            let content = UNMutableNotificationContent()
            
            if itemsExpiringToday.count == 1 {
                content.title = "You have \(itemsExpiringToday.count) item expiring today."
                content.subtitle = "Make sure to eat it up!"
            } else {
                content.title = "You have \(itemsExpiringToday.count) items expiring today - make sure to eat them up!"
                content.subtitle = "Make sure to eat them up!"

            }
            content.body = "auhhhhh"
            content.badge = 1
            content.sound = UNNotificationSound.default()
            content.categoryIdentifier = ""
            
            let request = UNNotificationRequest(identifier: "aDay", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                print(error?.localizedDescription ?? "NO ERROR!")
            }
        } else {
            let calendar = Calendar.current
            let components = calendar.dateComponents( [.hour, .minute], from:date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            
            let content = UNMutableNotificationContent()
            
            content.title = "Hello "
            content.subtitle = "this is a test"
            content.body = "auhhhhh"
            content.badge = 1
            content.sound = UNNotificationSound.default()
            content.categoryIdentifier = ""
            
            let request = UNNotificationRequest(identifier: "aDay", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                print(error?.localizedDescription ?? "NO ERROR!")
            }
        }
    }
}

