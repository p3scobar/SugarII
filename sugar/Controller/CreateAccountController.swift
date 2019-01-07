//
//  CreateAccountController.swift
//  sugarDev
//
//  Created by Hackr on 10/29/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import Foundation
import UIKit
import MaterialActivityIndicator
import stellarsdk

class CreateAccountController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.hidesBackButton = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.darkBackground
        setupView()
        indicator.startAnimating()
        createWallet()
    }

    func createWallet() {
        WalletManager.generateKeyPair(mnemonic: KeychainHelper.mnemonic) { (keyPair) in
            let publicKey = keyPair.accountId
            guard let privateSeed = keyPair.secretSeed else {
                self.presentErrorAlert()
                return
            }
            Model.shared.publicKey = publicKey
            KeychainHelper.publicKey = publicKey
            KeychainHelper.privateSeed = privateSeed
            self.createStellarAccount(completion: { (success) in
                if success == true {
                    setupDefaultaAvatar()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
    }
    
    
    
    func createStellarAccount(completion: @escaping (Bool) -> Void) {
        WalletManager.createStellarTestAccount(accountID: KeychainHelper.publicKey, completion: { (response) in
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                if let _ = response as? Error {
                    self.presentErrorAlert()
                    completion(false)
                } else {
                    completion(true)
                }
            }
        })
    }
    
    func presentErrorAlert() {
        ErrorPresenter.showError(message: "Failed to create an account.", on: self) { (_) in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
 
    let indicator: MaterialActivityIndicatorView = {
        let view = MaterialActivityIndicatorView()
        view.color = .white
        view.lineWidth = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupView() {
        view.addSubview(indicator)
        
        indicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 60).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
