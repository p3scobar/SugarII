//
//  TabBar.swift
//  devberg
//
//  Created by Hackr on 3/30/18.
//  Copyright © 2018 Hackr. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class TabBar: UITabBarController {
    
    var unreadBadgeCount = 0 {
        didSet {
            DispatchQueue.main.async {
                if let item = self.tabBar.items?[2], self.unreadBadgeCount != 0 {
                    item.badgeValue = "\(self.unreadBadgeCount)"
                }
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barStyle = UIBarStyle.default
        self.tabBar.tintColor = Theme.highlight
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = Theme.white
        
        let timelineVC = TimelineController(style: .grouped)
        let timeline = UINavigationController(rootViewController: timelineVC)
        timeline.tabBarItem.title = "Home"
        timeline.tabBarItem.image = UIImage(named: "home")
        
        let chatsVC = ChatsController(style: .grouped)
        let chats = UINavigationController(rootViewController: chatsVC)
        chats.tabBarItem.title = "Chats"
        chats.tabBarItem.image = UIImage(named: "chat")
        
        let peopleVC = PeopleController(style: .grouped)
        let people = UINavigationController(rootViewController: peopleVC)
        people.tabBarItem.title = "People"
        people.tabBarItem.image = UIImage(named: "group")
        
        let walletVC = WalletController(style: .plain)
        let wallet = UINavigationController(rootViewController: walletVC)
        wallet.tabBarItem.title = "Wallet"
        wallet.tabBarItem.image = UIImage(named: "wallet")
    
        let accountVC = AccountController(style: .grouped)
        let account = UINavigationController(rootViewController: accountVC)
        account.tabBarItem.title = "Account"
        account.tabBarItem.image = UIImage(named: "person")
        
        self.viewControllers = [chats, people, wallet, account]

//        Model.shared.notificationAdded = { (notification) in
//            if notification.unread! == true {
//                self.unreadBadgeCount += 1
//            }
//        }
        
//        Model.shared.notificationRead = { (notification) in
//            self.unreadBadgeCount -= 1
//        }
        
    }
    
//    var unread: Int? {
//        get {
//            var unreadCount = 0
//            unreadCount = Model.shared.notifications.count
//            return unreadCount
//        }
//    }
    
    var tabBarIndex: Int = 0 {
        didSet {
            print("INDEX: \(tabBarIndex)")
            
        }
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if Model.shared.soundsEnabled {
            SoundKit.playSound(type: .tab)
        }
    }
    
    
}
