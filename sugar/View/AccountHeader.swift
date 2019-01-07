//
//  AccountHeader.swift
//  devberg
//
//  Created by Hackr on 4/4/18.
//  Copyright © 2018 Hackr. All rights reserved.
//


import UIKit
import Kingfisher
import Firebase

protocol AccountDelegate: class {
    func handleEditButtonTap()
    func handleEditProfilePic()
}

class AccountHeader: UIView {
    
    var delegate: AccountController?
    var tap: UIGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Theme.white
        setupView()
        tap = UITapGestureRecognizer(target: self, action: #selector(editProfilePic))

        profileImage.addGestureRecognizer(tap)
        setupNameAndProfileImage()
    }
    
    func setupNameAndProfileImage() {
        nameLabel.text = Model.shared.name
        usernameLabel.text = "@\(Model.shared.username)"
        let url = URL(string: Model.shared.profileImage)
        profileImage.kf.setImage(with: url)
    }
    
    
    @objc func editProfilePic() {
        delegate?.handleEditProfilePic()
    }
    
    
    @objc func handleFollow() {
        delegate?.handleEditButtonTap()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let profileImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 0
        view.layer.cornerRadius = 34
        view.layer.masksToBounds = true
        view.backgroundColor = Theme.unfilled
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.bold(28)
        label.textColor = Theme.darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.medium(18)
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bioLabel: UITextView = {
        let view = UITextView()
        view.font = Theme.medium(18)
        view.textContainerInset = UIEdgeInsetsMake(10, 15, 0, 15)
        view.textColor = Theme.darkText
        view.isEditable = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(Theme.white, for: .normal)
        button.backgroundColor = Theme.gray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var contentSeparatorView: UIView = {
        let view = UIView()
        view.layer.borderColor = Theme.borderColor.cgColor
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    lazy var bottomSeparatorView: UIView = {
        let view = UIView()
        view.layer.borderColor = Theme.borderColor.cgColor
        view.layer.borderWidth = 1.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    func setupView() {
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        addSubview(editButton)
        addSubview(bottomSeparatorView)
        
        editButton.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        editButton.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 108).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 108).isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant:-20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 0).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        bioLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bioLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bioLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive = true
        bioLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    
        
        bottomSeparatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomSeparatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        bottomSeparatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    
    
    
}
