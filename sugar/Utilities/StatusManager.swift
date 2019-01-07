//
//  StatusManager.swift
//  sugarDev
//
//  Created by Hackr on 10/20/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import Foundation
import Firebase

struct StatusManager {
    
    static func newStatus(text: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let name = Model.shared.name
        let username = Model.shared.username
        let userImage = Model.shared.profileImage
        let id = UUID.init().uuidString
        let timestamp = Firebase.FieldValue.serverTimestamp()
        let values: [String:Any] = ["id":id,
                                    "text":text,
                                    "timestamp":timestamp,
                                    "userId":userId,
                                    "name":name,
                                    "username":username,
                                    "userImage":userImage]
        let ref = db.collection("status").document(id)
        ref.setData(values) { (err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
            }
        }
    }
    
    static func fetchTimeline(completion: @escaping ([Status]) -> Void) {
        let ref = db.collection("status").order(by: "timestamp", descending: true)
        ref.getDocuments { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
                completion([])
            } else {
                var timeline: [Status] = []
                snap?.documents.forEach({ (data) in
                    let status = Status(data: data.data())
                    timeline.append(status)
                })
                completion(timeline)
            }
        }
    }
    
}
