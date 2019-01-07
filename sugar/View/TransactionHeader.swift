//
//  TransactionHeader.swift
//  sugarDev
//
//  Created by Hackr on 12/9/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import UIKit

class TransactionHeader: UIView {
    
    var payment: Payment? {
        didSet {
            if let amount = payment?.amount {
                amountLabel.text = amount.currency(3)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var amountLabel: UILabel = {
        let frame = CGRect(x: 0, y: 40, width: self.frame.width, height: 80)
        let view = UILabel(frame: frame)
        view.textColor = Theme.darkText
        view.textAlignment = .center
        view.font = Theme.bold(36)
        return view
    }()

    lazy var currencyLabel: UILabel = {
        let frame = CGRect(x: 0, y: 110, width: self.frame.width, height: 40)
        let view = UILabel(frame: frame)
        view.textColor = Theme.gray
        view.textAlignment = .center
        view.text = "Troy Oz."
        view.font = Theme.medium(20)
        return view
    }()
    
    lazy var separator: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.frame.height-0.6, width: self.frame.width, height: 0.6))
        view.backgroundColor = Theme.borderColor
        return view
    }()
    
    func setupView() {
        addSubview(amountLabel)
        addSubview(currencyLabel)
        addSubview(separator)
    }
    
}
