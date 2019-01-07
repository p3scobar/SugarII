//
//  TimlineController.swift
//  sugarDev
//
//  Created by Hackr on 10/19/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import Foundation
import UIKit

class TimelineController: UITableViewController {
    
    let statusCell = "statusCell"
    var searchController: UISearchController!
    
    var timeline: [Status] = [] {
        didSet {
            reloadSections()
        }
    }
    
    func reloadSections() {
        let indexSet = NSIndexSet(index: 0) as IndexSet
        tableView.reloadSections(indexSet, with: .fade)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Today"
        tableView.register(StatusCell.self, forCellReuseIdentifier: statusCell)
        tableView.backgroundColor = Theme.darkBackground
        tableView.separatorColor = Theme.borderColor
        tableView.tableFooterView = UIView()
        
        self.definesPresentationContext = true
        let vc = ResultsController(style: .plain)
        searchController = UISearchController(searchResultsController: vc)
        searchController.delegate = vc
        searchController.searchResultsUpdater = vc
        vc.navController = self.navigationController
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.tintColor = Theme.white
        searchController.searchBar.keyboardAppearance = .dark
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let composeIcon = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        let compose = UIBarButtonItem(image: composeIcon, style: .done, target: self, action: #selector(handleCompose))
        tableView.separatorInset = UIEdgeInsetsMake(0, 84, 0, 0)
        self.navigationItem.rightBarButtonItem = compose
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        fetchData()
    }
    
    @objc func handleCompose() {
        let vc = ComposeController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @objc func fetchData() {
        StatusManager.fetchTimeline { (feed) in
            self.timeline = feed
            self.refreshControl?.endRefreshing()
        }
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: statusCell, for: indexPath) as! StatusCell
        cell.backgroundColor = Theme.darkBackground
        cell.selectionStyle = .none
        cell.status = timeline[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return timeline[indexPath.row].height()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
