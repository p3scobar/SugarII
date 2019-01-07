//
//  Status.swift
//  sugarDev
//
//  Created by Hackr on 10/19/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class Status: NSObject {
    var id: String?
    var timestamp: Date?
    var text: String
    var userId: String
    var userImage: String
    var name: String
    var username: String
    var likeCount: Int
    var commentCount: Int
    var image: String?
    var link: String?
    var linkTitle: String?
    var linkImage: String?
    
    
    init(data: [String:Any]) {
        self.id = data["id"] as? String
        self.text = data["text"] as? String ?? ""
        self.userId = data["userId"] as? String ?? ""
        self.userImage = data["userImage"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        let date = data["timestamp"] as? Timestamp
        self.timestamp = date?.dateValue()
        self.likeCount = data["likeCount"] as? Int ?? 0
        self.commentCount = data["commentCount"] as? Int ?? 0
        self.image = data["image"] as? String
        self.link = data["link"] as? String
        self.linkTitle = data["linkTitle"] as? String
        self.linkImage = data["linkImage"] as? String
        
    }
}


extension Status {
    
    func height() -> CGFloat {
        var height: CGFloat = 80
        let width = UIScreen.main.bounds.width-84
        let textHeight = self.text.height(forWidth: width, font: Theme.regular(18))
        height += textHeight
        if self.image != nil {
            height += 190
        }
        if self.link != nil {
            height += 240
        }
        return height
    }
    
}
