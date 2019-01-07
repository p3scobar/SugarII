//
//  Activity.swift
//  devberg
//
//  Created by Hackr on 4/2/18.
//  Copyright © 2018 Hackr. All rights reserved.
//

import UIKit
import Firebase

class Activity: NSObject {
//
//    enum ActivityType {
//        case Follow
//        case Reply
//    }
    
    var id: String?
    var fromId: String?
    var fromProfilePic: String?
    var fromName: String?
    var fromUsername: String?
    var toId: String?
    var text: String?
    var unread: Bool?
    var status: String?
    var type: String?
    var timestamp: Date?
    
    init (data: [String:Any]) {
        id = data["id"] as? String
        fromId = data["fromId"] as? String
        fromProfilePic = data["fromProfilePic"] as? String
        fromName = data["fromName"] as? String
        fromUsername = data["fromUsername"] as? String
        toId = data["toId"] as? String
        text = data["text"] as? String
        unread = data["unread"] as? Bool
        status = data["status"] as? String
        let date = data["timestamp"] as? Timestamp
        timestamp = date?.dateValue()
        type = data["type"] as? String
        timestamp = date?.dateValue()
        
    }
    
}




