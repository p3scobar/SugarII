//
//  LoginToolbar.swift
//  devberg
//
//  Created by Hackr on 4/2/18.
//  Copyright © 2018 Hackr. All rights reserved.
//

import UIKit

class LoginToolbar: UIToolbar {
    
    var loginVc: LoginController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        barStyle = UIBarStyle.blackTranslucent
        setItems([passwordButton], animated: false)
    }

    let passwordButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Forgot Password?", style: .done, target: self, action: #selector(handleForgotPWTap))
        button.tintColor = Theme.white
        return button
    }()
    
    @objc func handleForgotPWTap() {
//        loginVc?.handleForgotPassword()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
