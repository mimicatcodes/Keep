//
//  AppDelegate.swift
//  Keep
//
//  Created by Luna An on 12/22/16.
//  Copyright © 2016 Mimicatcodes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let colorNormal = Colors.border
        let colorSelected = Colors.added
        
        if let font = UIFont(name: Fonts.montserratRegular, size: 16) {
            let navigationBarAppearace = UINavigationBar.appearance()
            navigationBarAppearace.titleTextAttributes = [NSFontAttributeName: font,  NSForegroundColorAttributeName: Colors.naviTitle]
            navigationBarAppearace.barTintColor = .white
            navigationBarAppearace.tintColor = Colors.button
            navigationBarAppearace.layer.borderColor = Colors.mainBorder.cgColor
            navigationBarAppearace.isTranslucent = false
            navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: Colors.button]
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

