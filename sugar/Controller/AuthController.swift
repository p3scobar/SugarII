//
//  AuthPhoneController.swift
//  devberg
//
//  Created by Hackr on 10/5/17.
//  Copyright © 2017 Hackr. All rights reserved.
//


import UIKit
import Firebase
import UITextView_Placeholder
import PhoneNumberKit

class AuthController: UIViewController, UIScrollViewDelegate {
    
    var phoneNumber: String = ""
    
    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: CGRect.zero)
        view.alwaysBounceVertical = true
        view.backgroundColor = Theme.darkBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        view.backgroundColor = Theme.darkBackground
        setupView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    


    @objc func requestToken() {
        guard let phone = phoneInput.text else { return }
        tokenInput.becomeFirstResponder()
        if phone.count < 9 {
            presentAlertController()
        }
        self.animateCodeButton()
        let formattedNumber = "+1\(phone)"
        PhoneAuthProvider.provider().verifyPhoneNumber(formattedNumber, uiDelegate: nil) { (verificationId, error) in
            if let error = error {
                print(error)
            } else {
                UserDefaults.standard.set(verificationId, forKey: "authVerificationId")
                self.phoneNumber = phone
            }
        }
    }
    
    
    func animateCodeButton() {
        let delay = 2.0
        self.buttonRequestToken.titleLabel?.pushTransition(0.4)
        self.buttonRequestToken.titleLabel?.text = "Sent!"
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+delay) {
            self.buttonRequestToken.titleLabel?.pushTransition(0.4)
            self.buttonRequestToken.titleLabel?.text = "Request Code"
        }
    }
    
    
    @objc func handleLogin() {
        guard let token = tokenInput.text else { return }
        let verificationId = UserDefaults.standard.string(forKey: "authVerificationId")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId!, verificationCode: token)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print(error ?? "")
                return
            } else {
                if let uid = user?.uid {
                    UserDefaults.standard.setValue(uid, forKey: "id")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    

    
    
    func presentAlertController() {
        
    }
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Coinberg"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Crowdsourced cryptocurrency news"
        label.textColor = UIColor.white.withAlphaComponent(0.4)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let statusView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.darkBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let phoneInput: UITextView = {
        let view = UITextView()
        view.textColor = .orange
        view.keyboardType = .numberPad
        view.textContainer.maximumNumberOfLines = 0
        view.placeholder = "Phone Number"
        view.placeholderColor = .lightGray
        view.backgroundColor = Theme.darkCharcoal
        view.layer.cornerRadius = 6
        view.autocapitalizationType = .words
        view.font = UIFont.systemFont(ofSize: 14)
        view.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tokenInput: UITextView = {
        let view = UITextView()
        view.textColor = .orange
        view.keyboardType = .numberPad
        view.textContainer.maximumNumberOfLines = 0
        view.placeholder = "Code"
        view.placeholderColor = .lightGray
        view.backgroundColor = Theme.darkCharcoal
        view.layer.cornerRadius = 6
        view.autocapitalizationType = .none
        view.font = UIFont.systemFont(ofSize: 14)
        view.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let buttonRequestToken: UIButton = {
        let button = UIButton()
        button.setTitle("Request Code", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(requestToken), for: .touchUpInside)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonSubmit: UIButton = {
        let button = UIButton()
        button.setTitle("Authenticate", for: .normal)
        button.backgroundColor = Theme.gray
        button.layer.cornerRadius = 4
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupView() {
        view.addSubview(scrollView)
        view.addSubview(statusView)
//        view.bringSubview(toFront: statusView)
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(subTitleLabel)
        scrollView.addSubview(phoneInput)
        scrollView.addSubview(tokenInput)
        scrollView.addSubview(buttonRequestToken)
        scrollView.addSubview(buttonSubmit)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        statusView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        statusView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        statusView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        statusView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 140).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        subTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        subTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        subTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        phoneInput.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 40).isActive = true
        phoneInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        phoneInput.widthAnchor.constraint(equalToConstant: view.frame.width*0.56).isActive = true
        phoneInput.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        tokenInput.topAnchor.constraint(equalTo: phoneInput.bottomAnchor, constant: 16).isActive = true
        tokenInput.leftAnchor.constraint(equalTo: phoneInput.leftAnchor).isActive = true
        tokenInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        tokenInput.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        buttonRequestToken.topAnchor.constraint(equalTo: phoneInput.topAnchor).isActive = true
        buttonRequestToken.bottomAnchor.constraint(equalTo: phoneInput.bottomAnchor).isActive = true
        buttonRequestToken.leftAnchor.constraint(equalTo: phoneInput.rightAnchor, constant: 14).isActive = true
        buttonRequestToken.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        buttonSubmit.topAnchor.constraint(equalTo: tokenInput.bottomAnchor, constant: 16).isActive = true
        buttonSubmit.leftAnchor.constraint(equalTo: phoneInput.leftAnchor).isActive = true
        buttonSubmit.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        buttonSubmit.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
}
