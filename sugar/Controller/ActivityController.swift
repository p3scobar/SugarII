//
//  ActivityController.swift
//  devberg
//
//  Created by Hackr on 4/2/18.
//  Copyright © 2018 Hackr. All rights reserved.
//


import UIKit
import SafariServices
import Firebase

class ActivityController: UITableViewController, UISearchControllerDelegate {
    
    var activityCell = "activityCell"
    
    var items = [Activity]() {
        didSet {
            if items.count == 0 {
                tableView.backgroundView = emptyView
            } else {
                reloadSections()
            }
        }
    }
    
    
    lazy var emptyView: EmptyView = {
        let view = EmptyView(frame: UIScreen.main.bounds)
        view.subLabel.text = "No activity to display yet."
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        self.navigationItem.title = "Activity"
        
        tableView.register(ActivityCell.self, forCellReuseIdentifier: activityCell)
        
        tableView.tableFooterView = UIView()
        tableView.separatorColor = Theme.borderColor
        view.backgroundColor = Theme.darkBackground
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        items = Model.shared.notifications
        Model.shared.notificationAdded = { (notification) in
            self.items.insert(notification, at: 0)
            if Model.shared.soundsEnabled {
                SoundKit.playSound(type: .tab)
            }
        }
       
    }
    
    
    @objc func pullToRefresh() {
        if Model.shared.soundsEnabled {
            DispatchQueue.main.async {
                
            }
        }
        loadData()
    }
    
    
    @objc func loadData() {
        ActivityManager.fetchNotifications { (activity) in
            self.items = activity
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
    }

    
    func reloadSections() {
        let indexSet = NSIndexSet(index: 0) as IndexSet
        tableView.reloadSections(indexSet, with: .automatic)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: activityCell, for: indexPath) as! ActivityCell
        let notification = items[indexPath.row]
        cell.activity = notification
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let activity = items[indexPath.row]
        if activity.type == "follow" {
            pushProfileController(userId: activity.fromId)
        }
        if activity.unread == true {
            activity.unread = false
            markAsRead(notificationId: activity.id)
        }
    }
    
    
    func markAsRead(notificationId: String?) {
        guard let id = notificationId else { return }
        ActivityManager.markAsRead(notificationId: id)
    }
    
    
    
    func pushProfileController(userId: String?) {
        guard userId != nil else { return }
        let vc = ProfileController(userId: userId!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func handleUserTap(userId: String) {
        let vc = ProfileController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

