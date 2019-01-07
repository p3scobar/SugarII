//
//  UserCell.swift
//  devberg
//
//  Created by Hackr on 4/1/18.
//  Copyright © 2018 Hackr. All rights reserved.
//


import UIKit
import Firebase
import Kingfisher


class UserCell: UITableViewCell {
    
    weak var user: User? {
        didSet {
            if let name = user?.name {
                self.nameLabel.text = name
            }
            
            if let username = user?.username {
                usernameLabel.text = "@\(username)"
            }
            
            if let image = user?.photo {
                let url = URL(string: image)
                self.profileImage.kf.setImage(with: url)
            }
        }
    }
    
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 18
        imageView.backgroundColor = Theme.unfilled
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.semibold(22)
        label.numberOfLines = 1
        label.textColor = Theme.darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.medium(18)
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = Theme.white
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(usernameLabel)
//        let bgView = UIView()
//        bgView.backgroundColor = Theme.tintColor
//        selectedBackgroundView = bgView
        
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor, constant: 0).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
