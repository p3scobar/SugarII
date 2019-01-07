//
//  CommentCell.swift
//  sugarDev
//
//  Created by Hackr on 5/17/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import Foundation
import UIKit

class CommentCell: UITableViewCell {
    
    var comment: Comment? {
        didSet {
            nameLabel.text = comment?.name
            commentLabel.text = comment?.text
    
            let url = URL(string: comment!.userImage)
            profileImage.kf.setImage(with: url)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let profileImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 16, y: 10, width: 44, height: 44))
        imageView.layer.cornerRadius = 18
        imageView.backgroundColor = Theme.unfilled
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.semibold(16)
        label.numberOfLines = 1
        label.textColor = Theme.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.medium(16)
        label.textColor = Theme.white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupView() {
        selectionStyle = .none
        backgroundColor = Theme.darkBackground
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(commentLabel)
        
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        commentLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor).isActive = true
        commentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        commentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        commentLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
        
        
    }
    
}
