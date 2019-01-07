//
//  MnemonicController.swift
//  sugarDev
//
//  Created by Hackr on 4/23/18.
//  Copyright © 2018 Stack. All rights reserved.
//


import Foundation
import UIKit
import stellarsdk

class MnemonicController: UITableViewController {
    
    let cellId = "cellId"
    let mnemonic: String = KeychainHelper.mnemonic
    
    lazy var header: UIView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140)
        let view = UIView(frame: frame)
        let instructionsLabel: UITextView = {
            let view = UITextView(frame: frame)
            view.textContainerInset = UIEdgeInsetsMake(30, 12, 10, 12)
            view.backgroundColor = Theme.lightBackground
            view.font = Theme.semibold(20)
            view.text = "Please write down this 12 word passphrase. It is the only way to recover your account."
            view.textColor = Theme.darkText
            return view
        }()
        view.addSubview(instructionsLabel)
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = header
        tableView.allowsSelection = false
        tableView.separatorColor = Theme.borderColor
        tableView.backgroundColor = Theme.lightBackground
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
        self.navigationItem.title = "Secret Phrase"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let words = mnemonic.components(separatedBy: .whitespaces)
        let word = words[indexPath.row]
        cell.textLabel?.text = word
        cell.textLabel?.font = Theme.semibold(18)
        return cell
    }
    
    
}
