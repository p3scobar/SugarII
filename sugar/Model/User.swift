//
//  User.swift
//  devberg
//
//  Created by Hackr on 10/6/17.
//  Copyright © 2017 Hackr. All rights reserved.
//


import UIKit
import Firebase


class User: NSObject {
    
    var id: String?
    var name: String?
    var email: String?
    var username: String?
    var photo: String?
    var bio: String?
    var publicKey: String?
    var blocked: [String:Bool]?
    var notificationKey: String?
    
    init (dictionary: [String:Any]) {
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        username = dictionary["username"] as? String
        photo = dictionary["photo"] as? String
        bio = dictionary["bio"] as? String
        blocked = dictionary["blocked"] as? [String:Bool]
        notificationKey = dictionary["notificationKey"] as? String
        publicKey = dictionary["publicKey"] as? String
    }
    

}
