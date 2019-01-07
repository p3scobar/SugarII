//
//  InputTextViewCell.swift
//  devberg
//
//  Created by Hackr on 4/4/18.
//  Copyright © 2018 Hackr. All rights reserved.
//


import UIKit

class InputTextViewCell: UITableViewCell, UITextViewDelegate {
    
    var indexPath: IndexPath!
    var delegate: InputTextCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        textView.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textFieldDidChange(indexPath: indexPath, value: textView.text ?? "")
    }
    
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.font = Theme.medium(18)
        view.textColor = Theme.darkText
        view.placeholderColor = Theme.gray
        view.backgroundColor = .white
        view.keyboardAppearance = .dark
        view.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    func setupView() {
        addSubview(textView)
        
        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
