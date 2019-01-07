//
//  LinkViewLarge.swift
//  sugarDev
//
//  Created by Hackr on 4/18/18.
//  Copyright © 2018 Stack. All rights reserved.
//
//
//import Foundation
//
//class LinkViewLarge: LinkView {
//    override func setupView() {
//        addSubview(mainTextLabel)
//        addSubview(urlLabel)
//        addSubview(imageView)
//
//        backgroundColor = Theme.darkBackground
//        
//        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
//
//        mainTextLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
//        mainTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
//        mainTextLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
//
//        urlLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
//        urlLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
//        urlLabel.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: 10).isActive = true
//
//    }
//}
