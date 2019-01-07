//
//  LoggedOutView.swift
//  devberg
//
//  Created by Hackr on 10/4/17.
//  Copyright © 2017 Hackr. All rights reserved.
//

import UIKit
import Firebase

class LoggedOutView: UIView {
    
    var navigationController: UINavigationController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Theme.tintColor
        setupView()
    }
    
    @objc func doPhoneAuth() {
        let vc = AuthController()
        let navVC = UINavigationController(rootViewController: vc)
        self.navigationController?.present(navVC, animated: true, completion: nil)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in to Continue"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Become a developer. Earn money remotely."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign in", for: .normal)
        button.backgroundColor = Theme.gray
        button.layer.cornerRadius = 4
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(doPhoneAuth), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupView() {
        addSubview(titleLabel)
        addSubview(detailsLabel)
        addSubview(signUpButton)
        
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -20).isActive = true
        
        detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        detailsLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 30).isActive = true
        detailsLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: -30).isActive = true
        
        signUpButton.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 40).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    }
    
}
