//
//  ReceiptView.swift
//  sugarDev
//
//  Created by Hackr on 5/21/18.
//  Copyright © 2018 Stack. All rights reserved.
//


protocol ReceiptViewDelegate: class {
    func handleCancel()
}

import UIKit

class ReceiptView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let cellID = "cellID"
    var values: [(String,String)]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var delegate: ReceiptViewDelegate?
    
    convenience init(type: PaymentType, amount: Double, frame: CGRect) {
        self.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(InputTextCell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        setupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.isScrollEnabled = false
        view.separatorInset = UIEdgeInsets.zero
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let titleView: UILabel = {
        let label = UILabel()
        label.text = "Success"
        label.textAlignment = .center
        label.font = Theme.bold(20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = Theme.semibold(18)
        button.setTitleColor(Theme.darkGray, for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleCancel() {
        delegate?.handleCancel()
    }
    
    func setupView() {
        addSubview(tableView)
        addSubview(titleView)
        addSubview(doneButton)
        
        tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor).isActive = true
        
        titleView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        doneButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        doneButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! InputTextCell
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.titleLabel.textColor = Theme.lightGray
        cell.valueInput.textColor = .white
        if let value = values?[indexPath.row] {
            cell.textLabel?.text = value.0
            cell.valueInput.text = value.1
            cell.valueInput.font = Theme.medium(16)
            cell.valueInput.isEnabled = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
