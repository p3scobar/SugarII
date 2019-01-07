//
//  WalletController.swift
//  sugarDev
//
//  Created by Hackr on 4/19/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import UIKit
import Foundation

class WalletController: UITableViewController, WalletHeaderDelegate {
    
    var walletCell = "activityCell"
    var standardCell = "standardCell"
    
    var payments = [Payment]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        refresh(nil)
        fetchTransactions()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var header: WalletHeaderView = {
        let view = WalletHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.delegate = self
        refreshControl = UIRefreshControl()
        self.navigationItem.title = "Wallet"
        tableView.tableHeaderView = header
        tableView.tableFooterView = UIView()
        tableView.register(StandardCell.self, forCellReuseIdentifier: standardCell)
        tableView.register(PaymentCell.self, forCellReuseIdentifier: walletCell)
        tableView.separatorColor = Theme.borderColor
        view.backgroundColor = Theme.lightBackground
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        streamTransactions()
    }
    
    func fetchTransactions() {
        WalletManager.fetchTransactions { (payments) in
            self.payments = payments
        }
    }
    
    func streamTransactions() {
        WalletManager.streamPayments { (payment) in
            self.payments.insert(payment, at: 0)
        }
    }
    
    @objc func refresh(_ sender: UIRefreshControl?) {
        WalletManager.getAccountDetails { [weak self] balance in
            DispatchQueue.main.async {
                sender?.endRefreshing()
                self?.header.balance = balance
                if Model.shared.soundsEnabled {
                    
                }
            }
        }
    }
    
    
    func reloadSections() {
        let indexSet = NSIndexSet(index: 0) as IndexSet
        tableView.reloadSections(indexSet, with: .none)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return payments.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: standardCell, for: indexPath) as! StandardCell
            cell.textLabel?.text = "Buy Gold"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: walletCell, for: indexPath) as! PaymentCell
            cell.payment = payments[indexPath.row]
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            presentOrderController()
        } else {
            pushTransactionController(payments[indexPath.row])
        }
    }
    
    
    func presentOrderController() {
        let vc = AmountController(type: .buy, publicKey: nil, username: nil)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func pushTransactionController(_ payment: Payment) {
        let vc = TransactionController(payment: payment)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func handleQRTap() {
        let vc = QRController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    

    
}
