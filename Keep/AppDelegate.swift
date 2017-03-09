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
        
        checkOnboardingStatus()
        setUpLocalNotification()
        styleNavigationAndTapBarElements()
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

extension AppDelegate {
    
    fileprivate func checkOnboardingStatus(){
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: Identifiers.Storyboard.main, bundle: nil)
        var initialVC = storyboard.instantiateViewController(withIdentifier: Identifiers.Storyboard.onboarding)

        if UserDefaults.standard.bool(forKey: Keys.UserDefaults.onboardingComplete) {
            initialVC = storyboard.instantiateViewController(withIdentifier: Identifiers.Storyboard.mainApp)
        }
        
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
    }
    
    fileprivate func setUpLocalNotification(){
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (allowed, error) in
            if allowed {
                print("success")
            } else {
                print("Not allowed")
            }
        }
        
        if let hour = UserDefaults.standard.value(forKey: Keys.UserDefaults.hour) as? Int, let minute = UserDefaults.standard.value(forKey: Keys.UserDefaults.minute) as? Int {
            print("Hour is \(hour) and minute is \(minute)")
        } else {
            UserDefaults.standard.set(10, forKey: Keys.UserDefaults.hour)
            UserDefaults.standard.set(30, forKey: Keys.UserDefaults.minute)
            Helper.setUpNotification(hour: 10, minute: 30)
        }
    }
    
    fileprivate func styleNavigationAndTapBarElements(){
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
    }

}

