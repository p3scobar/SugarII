//
//  KeychainHelper.swift
//  sugarDev
//
//  Created by Hackr on 4/23/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import KeychainSwift
import Foundation

class KeychainHelper: NSObject {
    
    static var mnemonic: String {
        get { return KeychainSwift().get("mnemonic") ?? ""}
        set (key) { KeychainSwift().set(key, forKey: "mnemonic")
            print("Saving mnemonic: \(mnemonic)")
        }
    }
    
    static var publicKey: String {
        get { return KeychainSwift().get("publicKey") ?? "" }
        set (pk) { KeychainSwift().set(pk, forKey: "publicKey")
            UserManager.updateUserInfo(values: ["publicKey":pk])
            print("Saving Public Key: \(publicKey)")
        }
    }
    
    static var privateSeed: String {
        get { return KeychainSwift().get("privateSeed") ?? "" }
        set (sk) { KeychainSwift().set(sk, forKey: "privateSeed")
            print("Saving Private Seed: \(privateSeed)")
        }
    }
    
}
