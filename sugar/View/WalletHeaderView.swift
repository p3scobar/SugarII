//
//  WalletHeaderView.swift
//  sugarDev
//
//  Created by Hackr on 4/23/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import Foundation
import UIKit
import QRCode

protocol WalletHeaderDelegate: class {
    func handleQRTap()
}

class WalletHeaderView: UIView {
    
    var delegate: WalletHeaderDelegate?
    
    var balance: String = "0.000" {
        didSet {
            balanceLabel.text = balance
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Theme.darkGray
        setupView()
        setQRCode()
    }
    
    func setQRCode() {
        let publicKey = KeychainHelper.publicKey
        let qrCode = QRCode(publicKey)
        qrView.image = qrCode?.image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.font = Theme.bold(24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "TROY OZ."
        label.font = Theme.medium(18)
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var qrView: UIImageView = {
        let frame = CGRect(x: 0, y: 0, width: 72, height: 72)
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    private lazy var bottomLine: UIView = {
        let view = UIView()
        view.layer.borderColor = Theme.borderColor.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    @objc func handleQRTap() {
        delegate?.handleQRTap()
    }
    
    func setupView() {
        addSubview(container)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleQRTap))
        container.addGestureRecognizer(tap)
        container.addSubview(balanceLabel)
        container.addSubview(currencyCodeLabel)
        container.addSubview(qrView)
        
        addSubview(bottomLine)
        
        container.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        container.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        container.heightAnchor.constraint(equalToConstant: 100).isActive = true
        container.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        
        qrView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        qrView.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16).isActive = true
        qrView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        qrView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        balanceLabel.leftAnchor.constraint(equalTo: qrView.leftAnchor).isActive = true
        balanceLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16).isActive = true
        balanceLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -16).isActive = true
        balanceLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        currencyCodeLabel.leftAnchor.constraint(equalTo: balanceLabel.leftAnchor).isActive = true
        currencyCodeLabel.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -20).isActive = true
        currencyCodeLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 20).isActive = true
        currencyCodeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
//        bottomLine.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        bottomLine.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        bottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
//        bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
}
