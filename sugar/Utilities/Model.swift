//
//  dataSource.swift
//  devberg
//
//  Created by Hackr on 10/3/17.
//  Copyright © 2017 Hackr. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Firebase

class Model {
    
    var notifications = [Activity]()
    var notificationAdded: ((Activity) -> Void)?
    var notificationRead: ((String) -> Void)?
    var favorites: [String:Bool] = [:]
    
//    var chatsDictionary: [String:Chat] = [:]
    
    static let shared: Model = Model()
    
    var userId: String {
        get { return UserDefaults.standard.string(forKey: "userId") ?? "" }
        set (name) { UserDefaults.standard.setValue(name, forKey: "userId") }
    }
    
    var email: String {
        get { return UserDefaults.standard.string(forKey: "email") ?? "" }
        set (param) { UserDefaults.standard.setValue(param, forKey: "email") }
    }
    
    var name: String {
        get { return UserDefaults.standard.string(forKey: "name") ?? "" }
        set (param) { UserDefaults.standard.setValue(param, forKey: "name") }
    }
    
    var username: String {
        get { return UserDefaults.standard.string(forKey: "username") ?? "" }
        set (param) { UserDefaults.standard.setValue(param, forKey: "username") }
    }
    
    var profileImage: String {
        get { return UserDefaults.standard.string(forKey: "profileImage") ?? "" }
        set (param) { UserDefaults.standard.setValue(param, forKey: "profileImage") }
    }

    var publicKey: String {
        get { return UserDefaults.standard.string(forKey: "publicKey") ?? "" }
        set (param) { UserDefaults.standard.setValue(param, forKey: "publicKey") }
    }
    
    var bio: String {
        get { return UserDefaults.standard.string(forKey: "bio") ?? "" }
        set (param) { UserDefaults.standard.setValue(param, forKey: "bio") }
    }
    
    var soundsEnabled: Bool {
        get { return UserDefaults.standard.bool(forKey: "soundEnabled") }
        set (enabled) { UserDefaults.standard.set(enabled, forKey: "soundEnabled") }
    }
    
    var blocked: [String:Bool]?
    
    init() {}
    
    deinit {
        listener?.remove()
        print("deinit Model.")
    }
    
    func fetchNotifications() {
        ActivityManager.fetchNotifications { (notifications) in
            self.notifications = notifications
        }
    }

    
    var listener: ListenerRegistration?
    
    fileprivate func attachNotificationListener() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = db.collection("notifications")
            .whereField("toId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
        listener = ref.addSnapshotListener { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                snap?.documentChanges.forEach({ (change) in
                    if (change.type == .added) {
                        let item = Activity(data: change.document.data())
                        self.notifications.append(item)
                        self.notificationAdded?(item)
                        return
                    }
                    if (change.type == .modified) {
                        if let id = change.document.data()["id"] as? String {
                            self.notificationRead?(id)
                            return
                        }
                    }
                })
            }
        }
    }
    
 
}




