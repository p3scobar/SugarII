//
//  TransactionController.swift
//  sugarDev
//
//  Created by Hackr on 5/21/18.
//  Copyright © 2018 Stack. All rights reserved.
//


import Foundation
import UIKit
import UIKit

class TransactionController: UITableViewController {
    
    var username = "" {
        didSet {
            tableView.reloadData()
        }
    }
    
    let cellId = "cellId"
    var payment: Payment!
    
    
    lazy var header: TransactionHeader = {
        let view = TransactionHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 180))
        view.payment = self.payment
        return view
    }()
    
    convenience init(payment: Payment) {
        self.init(style: .plain)
        self.payment = payment
        fetchUsername(payment: payment)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = header
        view.backgroundColor = Theme.lightBackground
        tableView.backgroundColor = Theme.lightBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = Theme.borderColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(InputTextCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        self.navigationItem.title = "Transaction"
        self.navigationController?.navigationBar.tintColor = .white
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func fetchUsername(payment: Payment) {
        if let pk = KeychainHelper.publicKey != payment.from ? payment.from : payment.to {
            UserManager.fetchUserFromPublicKey(pk) { (user) in
                guard let username = user?.username else { return }
                self.username = username
            }
        }
    }
    
    var isReceived: Bool {
        return payment.paymentType == .receive
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! InputTextCell
        cell.valueInput.isEnabled = false
        switch indexPath.row {
        case 0:
            if isReceived {
                cell.titleLabel.text = "From"
            } else {
                cell.titleLabel.text = "To"
            }
        cell.valueInput.text = "@\(username)"
        case 1:
            cell.titleLabel.text = "Date"
            let date = payment.timestamp
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            cell.valueInput.text = formatter.string(from: date)
        default:
            break
        }
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
