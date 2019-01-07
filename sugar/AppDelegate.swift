//
//  AppDelegate.swift
//  sugar
//
//  Created by Hackr on 4/11/18.
//  Copyright © 2018 Hackr. All rights reserved.
//


import UIKit
import CoreData
import Firebase
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        /// Appearance Customization:
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let tabBar = TabBar()
        window?.rootViewController = tabBar
        
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = Theme.white
        UINavigationBar.appearance().barTintColor = Theme.darkGray
        UINavigationBar.appearance().backgroundColor = Theme.darkGray
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().prefersLargeTitles = true
        
        
        let onesignalInitSettings: [AnyHashable : Any] = [kOSSettingsKeyAutoPrompt: false]
        
//        let notificationReceived: OSHandleNotificationReceivedBlock = { notification in
//            print("Received Notification: \(notification!.payload.notificationID)")
//        }
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "c61ffe6c-70e6-4c1a-ba62-8f9b8bde4497",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.none;
        

        
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }

        application.registerForRemoteNotifications()
        
        return true
    }
    
    
    func notificationReceived() {
        
    }
    
    
    
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let firebaseAuth = Auth.auth()
//        //At development time we use .sandbox
//        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
//        //At time of production it will be set to .prod
//        Messaging.messaging().apnsToken = deviceToken
//    }
    
    
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
        dbRealtime.removeAllObservers()
    }
    
   
    
}


