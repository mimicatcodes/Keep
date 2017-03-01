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
    
    static func setUpNotification(hour:Int, minute:Int){
        
        print("-------------------- \(hour) and \(minute)")
        
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
            content.title = "Testing title"
            content.body = "Testing title"
            content.categoryIdentifier = "reminder"
            //content.userInfo = ["": ""]
            content.sound = .default()
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            
        } else {
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            
            let content = UNMutableNotificationContent()
            content.title = "Testing title 2"
            content.body = "Testing title 2"
            content.categoryIdentifier = "reminderTwo"
            //content.userInfo = ["": ""]
            content.sound = .default()
            
            print(UserDefaults.standard.value(forKey: "hour") as? Int ?? "NO HOUR ----")
            print(UserDefaults.standard.value(forKey: "minute") as? Int ?? "NO MINUTE -----")
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }
    
    static func setLocalNotification(date: Date) {
        let store = DataStore.sharedInstance
        let components = Calendar.current.dateComponents( [.hour, .minute], from:date)
        var itemsExpiringToday:[Item] = []
        for item in store.allItems {
            if daysBetweenTwoDates(start: Date(), end: item.exp) == 0 {
                itemsExpiringToday.append(item)
            }
        }
        
        if itemsExpiringToday.count > 0 {
            
            let notificationCenter = UNUserNotificationCenter.current()
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
            
            let request = UNNotificationRequest(identifier: "expNotification", content: content, trigger: trigger)
            notificationCenter.add(request) { (error) in
                print(error?.localizedDescription ?? "\(request.content)")
            }
        } else {
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            
            let content = UNMutableNotificationContent()
            
            content.title = "TEST"
            content.subtitle = "Open Keep and see what you can make for lunch today!"
            content.body = "TEST"
            content.badge = 1 //?
            content.sound = UNNotificationSound.default()
            content.categoryIdentifier = ""
            
            let request = UNNotificationRequest(identifier: "noExpNotification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                print(error?.localizedDescription ?? "\(request.content)")
            }
        }
    }
}

