//
//  EmptyView.swift
//  devberg
//
//  Created by Hackr on 4/10/18.
//  Copyright © 2018 Hackr. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = Theme.darkBackground
    }
    
    let subLabel: UITextView = {
        let label = UITextView()
        label.font = Theme.medium(18)
        label.backgroundColor = .clear
        label.isEditable = false
        label.textContainer.lineBreakMode = .byTruncatingTail
        label.textColor = Theme.lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(subLabel)
        
        subLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50).isActive = true
        subLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        subLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        subLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }

}
