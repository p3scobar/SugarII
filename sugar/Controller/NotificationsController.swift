//
//  NotificationsController.swift
//  devberg
//
//  Created by Hackr on 4/5/18.
//  Copyright © 2018 Hackr. All rights reserved.
//


import UIKit
import OneSignal

class NotificationsController: UITableViewController {
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        if Model.shared.soundsEnabled {
            toggleSound.isOn = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var notificationCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Notifications"
        cell.accessoryView = toggleNotifications
        cell.textLabel?.font = Theme.medium(18)
        cell.textLabel?.textColor = Theme.darkText
        return cell
    }()
    
    lazy var soundCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Sounds"
        cell.textLabel?.font = Theme.medium(18)
        cell.textLabel?.textColor = Theme.darkText
        cell.accessoryView = toggleSound
        return cell
    }()
    
    
    let toggleNotifications: UISwitch = {
        let item = UISwitch()
        item.onTintColor = Theme.highlight
        item.tintColor = Theme.gray
        item.addTarget(self, action: #selector(handleSwitchNotification), for: .valueChanged)
        return item
    }()
    
    let toggleSound: UISwitch = {
        let item = UISwitch()
        item.onTintColor = Theme.highlight
        item.tintColor = Theme.gray
        item.addTarget(self, action: #selector(handleSwitchSound), for: .valueChanged)
        return item
    }()
    
    
    
    var subscribed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Theme.lightBackground
        tableView.allowsSelection = false
        tableView.separatorColor = Theme.borderColor
        self.title = "Settings"
        setupView()
        OneSignal.promptForPushNotifications { (accepted) in
            if accepted {
                self.toggleNotifications.isOn = true
            } else {
                self.toggleNotifications.isOn = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        if status.subscriptionStatus.subscribed {
            toggleNotifications.isOn = true
        } else {
            toggleNotifications.isOn = false
        }
    }
 

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return self.soundCell
        case 1:
            return self.notificationCell
        default:
            return self.soundCell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
//    let detailsLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.textColor = .gray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
//    let footerView: UIView = {
//        let view = UIView()
//        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
//        return view
//    }()
    
    func setupView() {
//        view.addSubview(footerView)
//        tableView.tableFooterView = footerView
//
//        footerView.addSubview(detailsLabel)
//        footerView.addSubview(detailsLabel)
//
//        detailsLabel.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 15).isActive = true
//        detailsLabel.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -15).isActive = true
//        detailsLabel.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        
    }
    
    @objc func handleSwitchNotification() {
        if toggleNotifications.isOn {
            OneSignal.setSubscription(true)
        } else {
            OneSignal.setSubscription(false)
//            detailsLabel.text = "Notifications are currently muted"
//            detailsLabel.text = ""
        }
    }
    
    @objc func handleSwitchSound() {
        Model.shared.soundsEnabled = toggleSound.isOn
    }
    
    
    
}

