//
//  ProfileButton.swift
//  devberg
//
//  Created by Hackr on 4/1/18.
//  Copyright © 2018 Hackr. All rights reserved.
//


import Foundation
import UIKit

class ProfileButton: UIControl {
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                icon.tintColor = Theme.highlight
                titleLabel.textColor = Theme.gray
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if !isEnabled {
                icon.tintColor = Theme.lightGray
                titleLabel.textColor = Theme.lightGray
            }
        }
    }
    
    private var previousLabelTintColor: UIColor?
    private var previousImageTintColor: UIColor?
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.semibold(14)
        label.textAlignment = .center
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private lazy var icon: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.tintColor = Theme.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    convenience init(imageName: String, title: String) {
        self.init()
        icon.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = title
        setupView()
    }
    
    
    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        isHighlighted = true
        
        previousImageTintColor = Theme.gray
        previousLabelTintColor = Theme.gray
        
        icon.tintColor = Theme.white
        titleLabel.textColor = Theme.white
        sendActions(for: .touchDown)
    }
    
    override func touchesCancelled(_: Set<UITouch>, with _: UIEvent?) {
        isHighlighted = false
        
        icon.tintColor = previousImageTintColor
        titleLabel.textColor = previousLabelTintColor
    }
    
    override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        isHighlighted = false
        
        icon.tintColor = previousImageTintColor
        titleLabel.textColor = previousLabelTintColor
        
        sendActions(for: .touchUpInside)
    }
    
    
    func setupView() {
        addSubview(icon)
        addSubview(titleLabel)
        
        icon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        icon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10).isActive = true
        icon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}







