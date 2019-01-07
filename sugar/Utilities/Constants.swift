//
//  Constants.swift
//  sugarDev
//
//  Created by Hackr on 4/23/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import stellarsdk
import Foundation
import UIKit
import Firebase
import FirebaseDatabase

let db = Firestore.firestore()
let dbRealtime = Database.database().reference()

public struct HorizonServer {
    static let production = ""
    static let test = "https://horizon-testnet.stellar.org"
    static let url = HorizonServer.test
}

public struct Stellar {
    static let sdk = StellarSDK(withHorizonUrl: HorizonServer.url)
    static let network = Network.testnet
    
}

public struct Assets {
    
    enum AssetType: Int {
        
        case gold
        
        var issuerAccountID: String {
            switch self {
            case .gold:
                return "GDOEF6QTMVCAS5TMASOJVFKNXU3PTZONRIMYJWPVVUMUAX4U4I46DQ2D"
            }
        }
    }
    
}

