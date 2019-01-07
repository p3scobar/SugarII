//
//  ResultsController.swift
//  devberg
//
//  Created by Hackr on 4/9/18.
//  Copyright © 2018 Hackr. All rights reserved.
//


import UIKit
import Firebase

class ResultsController: UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate {
    
    let userCellSmall = "userCellSmall"
    let statusCell = "statusCell"
    let standardCell = "standardCell"
    var navController: UINavigationController?
    var searchController: UISearchController!
    
    var users: [User]? {
        didSet {
            reloadTable()
        }
    }
    
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.lightBackground
        tableView.register(UserCellSmall.self, forCellReuseIdentifier: userCellSmall)
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.separatorColor = Theme.borderColor
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsMake(0, 88, 0, 0)
    }
    
    
    @objc func fetchData(query: String) {
        UserManager.fetchUsers(query: query) { (users) in
            self.users?.removeAll()
            self.users = users
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard var query = searchController.searchBar.text else { return }
        query = query.lowercased()
        fetchData(query: query)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellSmall, for: indexPath) as! UserCellSmall
        let user = users?[indexPath.row]
        cell.user = user
        return cell
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = self.users?[indexPath.row]
        let vc = ProfileController()
        vc.user = user
        self.navController?.pushViewController(vc, animated: true)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
