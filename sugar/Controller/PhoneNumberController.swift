//
//  PhoneNumberController.swift
//  sugarDev
//
//  Created by Hackr on 10/29/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class PhoneNumberController: UIViewController, UITextFieldDelegate {
    
    var username = ""
    var available = false
    var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.text = Model.shared.username
        view.backgroundColor = Theme.darkBackground
        setupView()
        self.title = "Phone Number"
        
        saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
        self.navigationItem.rightBarButtonItem = saveButton
        inputField.delegate = self
        self.inputField.text = Model.shared.username
        inputField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        if !isModal {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    var isModal: Bool {
        return presentingViewController != nil ||
            navigationController?.presentingViewController?.presentedViewController === navigationController ||
            tabBarController?.presentingViewController is UITabBarController
    }
    
    @objc func handleSave() {
        guard available == true else { return }
        Model.shared.username = username
        if isModal {
            pushCreateAccountController()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func pushCreateAccountController() {
        let vc = CreateAccountController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushMnemonicController() {
        let vc = MnemonicController(style: .plain)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Select a Username"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let inputField: UITextField = {
        let field = UITextField()
        field.layer.cornerRadius = 8
        field.backgroundColor = Theme.tintColor
        field.font = Theme.medium(18)
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textColor = .white
        field.tintColor = .white
        field.keyboardType = .twitter
        field.keyboardAppearance = .dark
        field.textAlignment = .center
        field.textRect(forBounds: CGRect(x: 20, y: 0, width: 20, height: 10))
        field.placeholder = "@username"
        if field.placeholder != nil {
            field.attributedPlaceholder = NSAttributedString(string: field.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: Theme.gray])
        }
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var toolbar: UIToolbar = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        let bar = UIToolbar(frame: frame)
        bar.barStyle = .blackTranslucent
        return bar
    }()
    
    let resultsLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        label.textColor = Theme.gray
        label.font = Theme.medium(16)
        label.textAlignment = .center
        return label
    }()
    
    override var inputAccessoryView: UIView? {
        return toolbar
    }
    
    
    func setupView() {
        view.addSubview(label)
        view.addSubview(inputField)
        
        toolbar.addSubview(resultsLabel)
        
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        inputField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
        inputField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        inputField.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    
    @objc func textFieldDidChange() {
        available = false
        guard let text = inputField.text else { return }
        username = text
        UserManager.usernameAvailable(username: text) { (available) in
            if !available || text.count < 2 {
                self.resultsLabel.text = "Unavailable"
                self.saveButton.isEnabled = false
                self.available = false
                if self.username == Model.shared.username && text.count > 2 {
                    self.resultsLabel.text = "Hello @\(self.username)!"
                }
            } else {
                self.resultsLabel.text = "👍"
                self.available = true
                self.saveButton.isEnabled = true
            }
        }
    }
    
    
}

