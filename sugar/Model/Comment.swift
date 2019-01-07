//
//  Comment.swift
//  sugarDev
//
//  Created by Hackr on 5/17/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class Comment: NSObject {
    var id: String?
    var timestamp: Date?
    var text: String
    var userId: String
    var userImage: String
    var name: String
    var username: String
    
    init(data: [String:Any]) {
        self.id = data["id"] as? String
        self.text = data["text"] as? String ?? ""
        self.userId = data["userId"] as? String ?? ""
        self.userImage = data["userImage"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        let date = data["timestamp"] as? Timestamp
        self.timestamp = date?.dateValue()
    }
}
