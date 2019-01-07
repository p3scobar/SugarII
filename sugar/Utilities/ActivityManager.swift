//
//  ActivityManager.swift
//  devberg
//
//  Created by Hackr on 4/5/18.
//  Copyright © 2018 Hackr. All rights reserved.
//

import Foundation
import Firebase
import OneSignal

struct ActivityManager {
    
    static func newActivity_Status(toId: String, statusId: String, text: String) {
        let id = UUID().uuidString
        let timestamp = FieldValue.serverTimestamp()
        let fromId = Model.shared.username
        let fromName = Model.shared.name
        let fromUsername = Model.shared.username
        let profilePic = Model.shared.profileImage
        let ref = db.collection("notifications").document(id)
        let values: [String:Any] = ["id":id,
                                    "timestamp":timestamp,
                                    "fromId":fromId,
                                    "fromName":fromName,
                                    "fromUsername":fromUsername,
                                    "fromProfilePic":profilePic,
                                    "toId":toId,
                                    "text":text,
                                    "status":statusId,
                                    "type":"reply",
                                    "unread":true,
        ]
        ref.setData(values)
    }
    
    static func newActivity_Follow(toId: String) {
        let text = "Started following you."
        let id = UUID().uuidString
        let timestamp = FieldValue.serverTimestamp()
        let fromId = Model.shared.userId
        let fromName = Model.shared.name
        let fromUsername = Model.shared.username
        let profilePic = Model.shared.profileImage
        let ref = db.collection("notifications")
        let values: [String:Any] = ["id":id,
                                    "timestamp":timestamp,
                                    "fromId":fromId,
                                    "fromName":fromName,
                                    "fromUsername":fromUsername,
                                    "fromProfilePic":profilePic,
                                    "toId":toId,
                                    "text":text,
                                    "type":"follow",
                                    "unread":true,
                                    ]
        ref.addDocument(data: values)
    }
    
    
    static func pushNotification(toId: String, message: String) {
        UserManager.fetchNotificationKey(forUser: toId) { (key) in
            guard let notificationKey = key else { return }
        let name = Model.shared.name
        let data: [String:Any] = ["contents": ["en": message],
                                  "headings": ["en": name],
                                  "include_player_ids": [notificationKey]]
        OneSignal.postNotification(data)
        }
    }
    
    
    static func fetchNotifications(completion: @escaping ([Activity]) -> Swift.Void) {
        var items = [Activity]()
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = db.collection("notifications").whereField("toId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
        ref.getDocuments { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                guard let documents = snap?.documents else { return }
                for doc in documents {
                    let activity = Activity(data: doc.data())
                    items.append(activity)
                }
                completion(items)
            }
        }
    }
    
    
    static func markAsRead(notificationId:String) {
        let ref = db.collection("notifications").document(notificationId)
        ref.updateData(["unread":false]) { (err) in
            if let error = err {
                print(error.localizedDescription)
            }
        }
    }
    

    
    
    
}
