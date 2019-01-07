//
//  WelcomeController.swift
//  devberg
//
//  Created by Hackr on 4/2/18.
//  Copyright © 2018 Hackr. All rights reserved.
//

import Foundation
import UIKit

class WelcomeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = Theme.darkBackground
        self.navigationController?.isNavigationBarHidden = true
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    self.navigationController?.isNavigationBarHidden = true
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
//    let headline: UILabel = {
//        let view = UILabel()
//        view.text = "Sugar"
//        view.font = UIFont(name: "Avenir-Heavy", size: 48)
//        view.textColor = .white
//        view.textAlignment = .center
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()

    lazy var mainImageView: UIImageView = {
        let view = UIImageView(frame: self.view.frame)
        view.image = UIImage(named: "moon")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Already have an account? Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Theme.medium(16)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    lazy var signupButton: UIButton = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        let button = UIButton(frame: frame)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(Theme.black, for: .normal)
        button.titleLabel?.font = Theme.medium(18)
        button.backgroundColor = Theme.white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleLogin() {
        let vc = LoginController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleSignup() {
//        let vc = SignupController()
        let vc = UsernameController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupView() {
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        view.addSubview(mainImageView)
        view.sendSubview(toBack: mainImageView)
        
//        headline.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        headline.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        headline.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
//        headline.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        signupButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        signupButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        signupButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
}
