//
//  PaymentCell.swift
//  sugarDev
//
//  Created by Hackr on 4/23/18.
//  Copyright © 2018 Stack. All rights reserved.
//


import UIKit

class PaymentCell: UITableViewCell {
    
    var payment: Payment? {
        didSet {
            guard var amount = payment?.amount else { return }
            if payment!.paymentType == .send { amount = "-" + amount }
            amountLabel.text = amount
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.dateFormat = "MMM dd"
            let formattedDate = formatter.string(from: payment!.timestamp)
            titleLabel.text = formattedDate
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupViews()
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.darkText
        label.font = Theme.regular(18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = Theme.darkText
        label.font = Theme.regular(18)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(amountLabel)
        
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        amountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        amountLabel.leftAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        amountLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        amountLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
    }
}
