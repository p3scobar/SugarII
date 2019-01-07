//
//  ChatCell.swift
//  sugarDev
//
//  Created by Hackr on 5/28/18.
//  Copyright © 2018 Stack. All rights reserved.
//


import UIKit
import Firebase

class ChatCell: UserCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    var chat: Chat? {
        didSet {
            if chat!.isGroup {
                setupChannel()
            } else {
                setupNameAndProfileImage()
            }
            if let time = self.chat?.lastMessageSent {
                let date = Date(timeIntervalSince1970: time)
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                self.dateLabel.text = formatter.string(from: date)
            }
        }
    }
    
    fileprivate func setupChannel() {
        nameLabel.text = chat!.title
        if let chatImage = chat!.image {
        let url = URL(string: chatImage)
            profileImage.kf.setImage(with: url)
        }
        if let lastMessage = self.chat?.lastMessage {
            self.usernameLabel.text = lastMessage
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = Theme.semibold(14)
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupNameAndProfileImage() {
        if let partnerId = chat?.partnerId {
            UserManager.fetchUser(userId: partnerId) { (partner) in
                self.user = partner
                
                if let name = self.user?.name {
                    self.nameLabel.text = name
                }
                
                if let profileUrl = self.user?.photo {
                    let url = URL(string: profileUrl)
                    self.profileImage.kf.setImage(with: url)
                }
                
                if let lastMessage = self.chat?.lastMessage {
                    self.usernameLabel.text = lastMessage
                }
            }
        }
    }
    
    func setupView() {
        addSubview(dateLabel)
        
        dateLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        dateLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 6).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        
    }
    
}
