//
//  WalletManager.swift
//  sugarDev
//
//  Created by Hackr on 4/20/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import Foundation
import stellarsdk
import Firebase

struct WalletManager {
    
    static let mnemonic = Wallet.generate24WordMnemonic()
    static var keyPair: KeyPair?
    
    static func generateKeyPair(mnemonic: String, completion: @escaping (KeyPair) -> Void) {
        print(mnemonic)
        let keyPair = try! Wallet.createKeyPair(mnemonic: mnemonic, passphrase: nil, index: 0)
        completion(keyPair)
    }
    
    
    /// CREATE TEST ACCOUNT
    
    static func createStellarTestAccount(accountID:String, completion: @escaping (Any?) -> Swift.Void) {
        Stellar.sdk.accounts.createTestAccount(accountId: accountID) { (response) -> (Void) in
            switch response {
            case .success(let details):
                changeTrust(completion: { (trusted) in
                    print("Trustline set: \(trusted)")
                    print(details)
                    completion(details)
                })
            case .failure(let error):
                completion(error)
                print(error.localizedDescription)
            }
        }
    }
    
    
    static func getAccountDetails(completion: @escaping (String) -> Swift.Void) {
        guard Auth.auth().currentUser?.uid != nil else { return }
        print("*********** ACCOUNT DETAILS ***********")
        print("ACCOUNT ID: \(KeychainHelper.publicKey)")
        print("SEED: \(KeychainHelper.privateSeed)")
        let accountId = KeychainHelper.publicKey
        Stellar.sdk.accounts.getAccountDetails(accountId: accountId) { (response) -> (Void) in
            switch response {
            case .success(let accountDetails):
                accountDetails.balances.forEach({ (balance) in
                    if balance.assetCode == "GOLD" {
                        print("Issuer: \(balance.assetIssuer)")
                        print("Asset: \(balance.assetCode)")
                        print("Balance: \(balance.balance)")
                        completion(balance.balance)
                    }
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    static func changeTrust(completion: @escaping (Bool) -> Void) {
        guard let sourceKeyPair = try? KeyPair(secretSeed: KeychainHelper.privateSeed) else {
            completion(false)
            return
        }
        
        let issuerAccountID = Assets.AssetType.gold.issuerAccountID
        guard let issuerKeyPair = try? KeyPair(accountId: issuerAccountID) else {
            completion(false)
            return
        }
        
        guard let asset = Asset.init(type: AssetType.ASSET_TYPE_CREDIT_ALPHANUM4, code: "GOLD", issuer: issuerKeyPair) else {
            completion(false)
            return
        }
        
        Stellar.sdk.accounts.getAccountDetails(accountId: KeychainHelper.publicKey) { (response) -> (Void) in
            switch response {
            case .success(let accountResponse):
                do {
                    let changeTrustOperation = ChangeTrustOperation(sourceAccount: sourceKeyPair, asset: asset, limit: 10000000000)
                    
                    let transaction = try Transaction(sourceAccount: accountResponse,
                                                      operations: [changeTrustOperation],
                                                      memo: nil,
                                                      timeBounds: nil)
                    
                    try transaction.sign(keyPair: sourceKeyPair, network: Stellar.network)
                    
                    try Stellar.sdk.transactions.submitTransaction(transaction: transaction, response: { (response) -> (Void) in
                        switch response {
                        case .success(_):
                            completion(true)
                        case .failure(let error):
                            print(error.localizedDescription)
                            completion(false)
                        }
                    })
                    
                }
                catch {
                    completion(false)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
        
    }
    
    
    static func fetchAssets(completion: @escaping ([String]) -> Swift.Void) {
        Stellar.sdk.assets.getAssets { (response) -> (Void) in
            switch response {
            case .success(let details):
                for asset in details.records {
                    let assetResponse = asset as AssetResponse
                    print("Asset Amount: \(assetResponse.amount)")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    static func fetchTransactions(completion: @escaping ([Payment]) -> Swift.Void) {
        let accountId = KeychainHelper.publicKey
        guard accountId != "" else { return }
        var payments = [Payment]()
            Stellar.sdk.payments.getPayments(forAccount: accountId, from: nil, order: Order.descending, limit: 50) { (response) -> (Void) in
                switch response {
                case .success(let details):
                    for payment in details.records {
                        if let paymentResponse = payment as? PaymentOperationResponse {
                            print("PAYMENT DETAILS: \(paymentResponse)")
                            let isReceived = paymentResponse.from != accountId ? true : false
                            let values = ["amount":paymentResponse.amount,
                                          "to":paymentResponse.to,
                                          "from":paymentResponse.from,
                                          "id":paymentResponse.id,
                                          "date":paymentResponse.createdAt,
                                          "isReceived":isReceived,
                                          "assetType":paymentResponse.assetType,
                                          "assetCode":paymentResponse.assetCode ?? "",
                                          "assetIssuer":paymentResponse.assetIssuer ?? ""] as [String : Any]
                            let payment = Payment(data: values)
                            payments.append(payment)
                            
                            print("$$ TRANSACTION FETCHED $$:")
                            print("TRANSACTION: \(values)")
                        }
                        completion(payments)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    
    
    static func streamPayments(completion: @escaping (Payment) -> Swift.Void) {
            let accountId = KeychainHelper.publicKey
            let goldIssuer = Assets.AssetType.gold.issuerAccountID
            let issuingAccountKeyPair = try? KeyPair(accountId: goldIssuer)
            let GOLD = Asset(type: AssetType.ASSET_TYPE_CREDIT_ALPHANUM4, code: "GOLD", issuer: issuingAccountKeyPair)
            
            Stellar.sdk.payments.stream(for: .paymentsForAccount(account: accountId, cursor: "now")).onReceive { (response) -> (Void) in
                switch response {
                case .open:
                    break
                case .response(let id, let operationResponse):
                    if let paymentResponse = operationResponse as? PaymentOperationResponse {
                        if paymentResponse.assetCode == GOLD?.code {
                            let isReceived = paymentResponse.from != accountId ? true : false
                            let values = ["amount":paymentResponse.amount,
                                          "to":paymentResponse.to,
                                          "from":paymentResponse.from,
                                          "id":paymentResponse.id,
                                          "date":paymentResponse.createdAt,
                                          "isReceived":isReceived,
                                          "assetType":paymentResponse.assetType,
                                          "assetCode":paymentResponse.assetCode ?? "",
                                          "assetIssuer":paymentResponse.assetIssuer ?? ""] as [String : Any]
                            let payment = Payment(data: values)
                            completion(payment)
                            
                            print("Payment of \(paymentResponse.amount) GOLD from \(paymentResponse.sourceAccount) -  id \(id)" )
                        }
                    }
                case .error(let err):
                    print(err!.localizedDescription)
                }
            }
    }
    
    
    static func sendPayment(toAccountID: String, amount: Decimal, completion: @escaping (Bool) -> Void) {
        
        let issuerID = Assets.AssetType.gold.issuerAccountID
        
        guard let sourceKeyPair = try? KeyPair(secretSeed: KeychainHelper.privateSeed) else {
            print("NO SOURCE KEYPAIR")
            completion(false)
            return
        }
        
        guard let destinationKeyPair = try? KeyPair(accountId: toAccountID) else {
            print("NO DESTINATION KEYPAIR")
            completion(false)
            return
        }
        
        Stellar.sdk.accounts.getAccountDetails(accountId: sourceKeyPair.accountId) { (response) -> (Void) in
            
            switch response {
            case .success(let accountResponse):
                do {
                    guard let issuerKeyPair = try? KeyPair(accountId: issuerID) else {
                        print("NO ISSUER KEYPAIR")
                        DispatchQueue.main.async {
                            completion(false)
                        }
                        return
                    }
                    
                    let asset = Asset(type: AssetType.ASSET_TYPE_CREDIT_ALPHANUM4, code: "GOLD", issuer: issuerKeyPair)!
                    
                    let paymentOperation = PaymentOperation(sourceAccount: sourceKeyPair,
                                                            destination: destinationKeyPair,
                                                            asset: asset,
                                                            amount: amount)
                    
                    let transaction = try Transaction(sourceAccount: accountResponse,
                                                      operations: [paymentOperation],
                                                      memo: nil,
                                                      timeBounds:nil)
                    
                    
                    try transaction.sign(keyPair: sourceKeyPair, network: Stellar.network)
                    
                    try Stellar.sdk.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
                        
                        switch response {
                        case .success(_):
                            DispatchQueue.main.async {
                                completion(true)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            StellarSDKLog.printHorizonRequestErrorMessage(tag:"Post Payment Error", horizonRequestError:error)
                            DispatchQueue.main.async {
                                completion(false)
                            }
                        }
                    }
                    let failure = try transaction.getTransactionHashData(network: Stellar.network)
                    print(failure.description)
                }
                catch {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            case .failure(let error):
                StellarSDKLog.printHorizonRequestErrorMessage(tag:"Post Payment Error", horizonRequestError:error)
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    

    
}
