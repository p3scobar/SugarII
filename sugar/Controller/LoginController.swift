//
//  LoginController.swift
//  devberg
//
//  Created by Hackr on 4/2/18.
//  Copyright © 2018 Hackr. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    var email = ""
    let inputCell = "inputCell"
    var passphrase = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        navigationController?.navigationBar.prefersLargeTitles = false
        setupView()
//        self.navigationController?.navigationBar.barStyle = .default
//        self.navigationController?.navigationBar.barTintColor = .white
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.tintColor = .darkGray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
    }
    
    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: UIScreen.main.bounds)
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    @objc func handleSubmit() {
        guard passphrase.components(separatedBy: " ").count > 8 else {
            self.presentAlert(title: "Error", message: "Please include a passphrase.")
            return
        }
        UserManager.login(mnemonic: passphrase) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                ErrorPresenter.showError(message: "Login failed.", on: self)
            }
        }
    }
    
    
    func presentAlert(title: String, message: String?) {
        let alert = UIAlertController(title: "Sorry", message: message ?? "", preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func updatePassphrase(_ sender: UITextField) {
        guard let text = sender.text else { return }
        passphrase = text
    }
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Sign in With Your Passphrase"
        view.font = Theme.bold(36)
        view.textColor = .darkGray
        view.textAlignment = .center
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var inputLabel: UITextField = {
        let view = UITextField()
        view.font = Theme.semibold(18)
        view.textColor = .darkGray
        view.placeholder = "12 word passphrase"
        view.textAlignment = .center
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.backgroundColor = Theme.lightBackground
        view.layer.cornerRadius = 16
        view.addTarget(self, action: #selector(updatePassphrase), for: .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(inputLabel)
        
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40).isActive = true
        
        inputLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        inputLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        inputLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        inputLabel.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
    }
    
    
}
