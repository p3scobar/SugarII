//
//  DiscoverController.swift
//  devberg
//
//  Created by Hackr on 4/1/18.
//  Copyright © 2018 Hackr. All rights reserved.
//


import UIKit
import Firebase

class PeopleController: UITableViewController, UISearchControllerDelegate {
    
    let userCell = "UserCell"
    var searchController: UISearchController!

    var users = [User]() {
        didSet {
            reloadSections()
        }
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        refresh(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.lightBackground
        tableView.register(UserCell.self, forCellReuseIdentifier: userCell)
        title = "People"
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        self.definesPresentationContext = true
        let vc = ResultsController(style: .plain)
        searchController = UISearchController(searchResultsController: vc)
        searchController.delegate = vc
        searchController.searchResultsUpdater = vc
        vc.navController = self.navigationController
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.tintColor = Theme.white
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = Theme.lightBackground
        tableView.separatorColor = Theme.borderColor
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogin), name: Notification.Name("login"), object: nil)
    }
    
    @objc func handleLogin() {
        refresh(nil)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func refresh(_ sender: UIRefreshControl?) {
        guard let _ = Auth.auth().currentUser?.uid else { return }
        UserManager.fetchFavorites { [weak self] favorites in
            DispatchQueue.main.async {
                sender?.endRefreshing()
                self?.users = favorites ?? []
            }
        }
    }
    
    
    func reloadSections() {
//        let indexSet = NSIndexSet(index: 0) as IndexSet
//        tableView.reloadSections(indexSet, with: .none)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath) as! UserCell
        cell.profileImage.image = nil
        let user = self.users[indexPath.row]
        cell.user = user
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.item]
        let vc = ProfileController()
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
