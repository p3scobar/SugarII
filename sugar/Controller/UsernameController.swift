//
//  UsernameController.swift
//  devberg
//
//  Created by Hackr on 4/2/18.
//  Copyright © 2018 Hackr. All rights reserved.


import UIKit
import Foundation
import Firebase

class UsernameController: UIViewController, UITextFieldDelegate {

    var username = ""
    var available = false
    var saveButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.text = Model.shared.username
        view.backgroundColor = Theme.white
        setupView()
        self.title = "Username"

        saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSave))
        self.navigationItem.rightBarButtonItem = saveButton
        inputField.delegate = self
        self.inputField.text = Model.shared.username
        inputField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        if isModal {
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
//        }
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
        guard available == true && username != "" else { return }
        Model.shared.username = username
        if isModal {
            createAccount(username: username)
        } else {
            UserManager.updateUserInfo(values: ["username":username])
            self.navigationController?.popViewController(animated: true)
        }
    }

    func createAccount(username: String) {
        UserManager.signup(username: username) { (success) in
            if success == true {
                DispatchQueue.main.async {
                    let vc = CreateAccountController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
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
        field.backgroundColor = Theme.lightBackground
        field.font = Theme.medium(18)
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.textColor = Theme.darkText
        field.tintColor = Theme.highlight
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

        inputField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        inputField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
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


//
//import UIKit
//
//class UsernameController: UIViewController {
//
//    var saveButton: UIBarButtonItem!
//    var username = ""
//    var available = false
//
//    var email = ""
//    let inputCell = "inputCell"
//    var passphrase = ""
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupView()
//        saveButton = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSave))
//        self.navigationItem.rightBarButtonItem = saveButton
//        saveButton.isEnabled = false
////        if isModal {
////            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
////        }
//    }
//
//    @objc func handleCancel() {
//        dismiss(animated: true, completion: nil)
//    }
//
//    var isModal: Bool {
//        return presentingViewController != nil ||
//            navigationController?.presentingViewController?.presentedViewController === navigationController ||
//            tabBarController?.presentingViewController is UITabBarController
//    }
//
//    @objc func handleSave() {
//        guard available == true && username != "" else { return }
//        Model.shared.username = username
//        if isModal {
//            createAccount(username: username)
//        } else {
//            UserManager.updateUserInfo(values: ["username":username])
//            self.navigationController?.popViewController(animated: true)
//        }
//    }
//
//    func createAccount(username: String) {
//        UserManager.signup(username: username) { (success) in
//            if success == true {
//                DispatchQueue.main.async {
//                    let vc = CreateAccountController()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            }
//        }
//    }
//
//    let scrollView: UIScrollView = {
//        let view = UIScrollView(frame: UIScreen.main.bounds)
//        view.alwaysBounceVertical = true
//        view.backgroundColor = .white
//        view.showsVerticalScrollIndicator = false
//        return view
//    }()
//
//
//    func presentAlert(title: String, message: String?) {
//        let alert = UIAlertController(title: "Sorry", message: message ?? "", preferredStyle: .alert)
//        let done = UIAlertAction(title: "Done", style: .default, handler: nil)
//        alert.addAction(done)
//        self.present(alert, animated: true, completion: nil)
//    }
//
//
//    @objc func textFieldDidChange() {
//        available = false
//        guard let text = inputTextField.text else { return }
//        username = text
//        UserManager.usernameAvailable(username: text) { (available) in
//            if !available || text.count < 2 {
////                self.resultsLabel.text = "Unavailable"
//                self.saveButton.isEnabled = false
//                self.available = false
//                if self.username == Model.shared.username && text.count > 2 {
////                    self.resultsLabel.text = "Hello @\(self.username)!"
//                }
//            } else {
////                self.resultsLabel.text = "👍"
//                self.available = true
//                self.saveButton.isEnabled = true
//            }
//        }
//    }
//
//    lazy var titleLabel: UILabel = {
//        let view = UILabel()
//        view.text = "Select a username"
//        view.font = Theme.bold(36)
//        view.textColor = .darkGray
//        view.textAlignment = .center
//        view.numberOfLines = 2
//        view.lineBreakMode = .byWordWrapping
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    lazy var inputTextField: UITextField = {
//        let view = UITextField()
//        view.font = Theme.semibold(18)
//        view.textColor = .darkGray
//        view.placeholder = ""
//        view.textAlignment = .center
//        view.autocorrectionType = .no
//        view.autocapitalizationType = .none
//        view.backgroundColor = Theme.lightBackground
//        view.layer.cornerRadius = 16
//        view.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//
//    func setupView() {
//        view.addSubview(scrollView)
//        scrollView.addSubview(titleLabel)
//        scrollView.addSubview(inputTextField)
//
//        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40).isActive = true
//
//        inputTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        inputTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        inputTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
//        inputTextField.heightAnchor.constraint(equalToConstant: 72).isActive = true
//
//    }
//
//
//}
