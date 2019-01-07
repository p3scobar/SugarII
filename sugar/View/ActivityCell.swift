//
//  ActivityCell.swift
//  devberg
//
//  Created by Hackr on 4/5/18.
//  Copyright © 2018 Hackr. All rights reserved.
//

import Foundation
import UIKit

class ActivityCell: UserCell {
    
//    let unreadIndicator: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 12
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Theme.darkBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var activity: Activity? {
        didSet {
            if let name = activity?.fromName {
                self.nameLabel.text = name
            }
            if let text = activity?.text {
                usernameLabel.text = text
            }
            
            if let photo = activity?.fromProfilePic {
                let url = URL(string: photo)
                profileImage.kf.setImage(with: url)
            }
            usernameLabel.textColor = Theme.white
            nameLabel.textColor = Theme.gray
            if activity!.unread == true {
                backgroundColor = Theme.darkBackground
            }
        }
    }

    
    
}
