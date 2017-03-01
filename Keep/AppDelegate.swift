//
//  AppDelegate.swift
//  Keep
//
//  Created by Luna An on 12/22/16.
//  Copyright © 2016 Mimicatcodes. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UserDefaults.standard.set(10, forKey: "hour")
        UserDefaults.standard.set(30, forKey: "minute")
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (allowed, error) in
            if allowed {
                print("success")
            } else {
                print("Not allowed")
            }
        }
        
        if let hour = UserDefaults.standard.value(forKey: "hour") as? Int, let minute = UserDefaults.standard.value(forKey: "minute") as? Int {
            Helper.setUpNotification(hour: hour, minute: minute)
            print("Hour is \(hour) and minute is \(minute)")
        } else {
            print("Notifications cannot be sent")
        }
        
        let colorNormal = Colors.warmGreyFive
        let colorSelected = Colors.tealish
        
        if let font = UIFont(name: Fonts.montserratSemiBold, size: 16) {
            let navigationBarAppearace = UINavigationBar.appearance()
            navigationBarAppearace.titleTextAttributes = [NSFontAttributeName: font,  NSForegroundColorAttributeName: Colors.brownishGreyTwo]
            navigationBarAppearace.barTintColor = .white
            navigationBarAppearace.tintColor = Colors.warmGreyThree
            navigationBarAppearace.layer.borderColor = Colors.whiteFour.cgColor
            navigationBarAppearace.isTranslucent = false
        }
        
        if let font = UIFont(name: Fonts.latoRegular, size: 11.0) {
            let attributesNormal = [
                NSForegroundColorAttributeName: colorNormal,
                NSFontAttributeName : font
            ]
            
            let attributesSelected = [
                NSForegroundColorAttributeName : colorSelected,
                NSFontAttributeName : font
            ]
            
            UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
        }
        UITabBar.appearance().tintColor = colorSelected
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)// notification in the foreground
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Do something
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
    }
    
    
}

