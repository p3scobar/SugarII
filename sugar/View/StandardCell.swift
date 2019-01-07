//
//  StandardCell.swift
//  devberg
//
//  Created by Hackr on 4/10/18.
//  Copyright © 2018 Hackr. All rights reserved.
//

import UIKit

class StandardCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.textColor = Theme.darkText
        textLabel?.font = Theme.medium(18)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
