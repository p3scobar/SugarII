//
//  Payment.swift
//  sugarDev
//
//  Created by Hackr on 4/23/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import Foundation

enum PaymentType: String {
    case buy = "buy"
    case send = "send"
    case receive = "receive"
}

class Payment: NSObject {
    
    var id: String?
    var timestamp: Date
    var amount: String?
    var from: String?
    var to: String?
    var assetCode: String?
    var assetIssuer: String?
    var assetType: String?
    var isReceived: Bool
    var paymentType: PaymentType = .send
    
    init(data: [String:Any]) {
        id = data["id"] as? String
        timestamp = data["date"] as! Date
        amount = data["amount"] as? String
        to = data["to"] as? String
        from = data["from"] as? String
        assetCode = data["assetCode"] as? String
        assetIssuer = data["assetIssuer"] as? String
        assetType = data["assetType"] as? String
        isReceived = data["isReceived"] as! Bool
        if isReceived { paymentType = .receive }
        print(data)
        super.init()
    }
    
}
