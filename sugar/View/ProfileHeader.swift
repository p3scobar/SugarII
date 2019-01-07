//
//  ProfileHeader.swift
//  devberg
//
//  Created by Hackr on 4/1/18.
//  Copyright © 2018 Hackr. All rights reserved.
//


import UIKit
import Kingfisher
import Firebase


protocol ProfileDelegate: class {
    func handleMessageTap()
    func handlePayTap()
    func handleFavoriteTap()
}

class ProfileHeaderView: UIView {
    
    var profileDelegate: ProfileController?
    var statusHeight: CGFloat = 80.0
    
    var user: User? {
        didSet{
            if let name = user?.name {
                nameLabel.text = name
            }
            if let photo = user?.photo {
                let url = URL(string: photo)
                profileImage.kf.setImage(with: url)
            }
            if let username = user?.username {
                usernameLabel.text = "@\(username)"
            }
            
            if let bio = user?.bio {
                bioLabel.text = bio
            }
        }
    }
    
    var favorited = false {
        didSet {
            DispatchQueue.main.async {
                if self.favorited {
                    self.favoriteButton.isHighlighted = true
                    self.profileDelegate?.favorited = true
                } else {
                    self.favoriteButton.isHighlighted = false
                    self.profileDelegate?.favorited = false
                }
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
    
    
    @objc private func handleMessageTap() {
        profileDelegate?.handleMessageTap()
    }
    
    @objc private func handleFavoriteTap() {
        profileDelegate?.handleFavoriteTap()
    }
    
    @objc private func handlePayTap() {
        profileDelegate?.handlePay()
    }
    
    
    let profileImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 0
        view.layer.cornerRadius = 34
        view.layer.masksToBounds = true
        view.backgroundColor = Theme.unfilled
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
        label.font = Theme.semibold(20)
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bioLabel: UITextView = {
        let view = UITextView()
        view.font = Theme.semibold(18)
        view.textContainerInset = UIEdgeInsetsMake(10, 15, 0, 15)
        view.textColor = Theme.darkText
        view.isEditable = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: BUTTON BAR
    
    let messageButton: ProfileButton = {
        let button = ProfileButton(imageName: "chat", title: "Message")
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleMessageTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let favoriteButton: ProfileButton = {
        let button = ProfileButton(imageName: "star", title: "Favorites")
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleFavoriteTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var payButton: ProfileButton = {
        let button = ProfileButton(imageName: "coinFilled", title: "Pay")
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handlePayTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var contentSeparatorView: UIView = {
        let view = UIView()
        view.layer.borderColor = Theme.borderColor.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var bottomSeparatorView: UIView = {
        let view = UIView()
        view.layer.borderColor = Theme.borderColor.cgColor
        view.layer.borderWidth = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    func setupView() {
        addSubview(messageButton)
        addSubview(favoriteButton)
        addSubview(payButton)
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(bioLabel)
        addSubview(contentSeparatorView)
        addSubview(bottomSeparatorView)
        
        messageButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        messageButton.topAnchor.constraint(equalTo: contentSeparatorView.bottomAnchor).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        messageButton.widthAnchor.constraint(equalToConstant: frame.width/3).isActive = true
        
        favoriteButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: contentSeparatorView.bottomAnchor).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: frame.width/3).isActive = true
        
        payButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        payButton.topAnchor.constraint(equalTo: contentSeparatorView.bottomAnchor).isActive = true
        payButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        payButton.widthAnchor.constraint(equalToConstant: frame.width/3).isActive = true
        
        profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 108).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 108).isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant:-10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: 0).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: 0).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bioLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bioLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bioLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 15).isActive = true
        bioLabel.bottomAnchor.constraint(equalTo: contentSeparatorView.topAnchor).isActive = true
        
        contentSeparatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentSeparatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        contentSeparatorView.bottomAnchor.constraint(equalTo: bottomSeparatorView.topAnchor, constant: -80).isActive = true
        
        bottomSeparatorView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bottomSeparatorView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        bottomSeparatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }

}


