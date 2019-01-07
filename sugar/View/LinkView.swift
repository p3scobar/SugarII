//
//  LinkView.swift
//  sugarDev
//
//  Created by Hackr on 4/17/18.
//  Copyright © 2018 Stack. All rights reserved.
//
//
//import Foundation
//import UIKit
//class LinkView: UIView {
//
//    var link: Link? {
//        didSet {
//            if let title = self.link?.title {
//                self.mainTextLabel.text = title
//            }
//            if let domain = self.link?.url {
//                self.urlLabel.text = domain
//                print(domain)
//            }
//            guard let urlString = self.link?.imageUrl else { return }
//            let url = URL(string: urlString)
//            self.imageView.kf.setImage(with: url)
//        }
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    lazy var mainTextLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
//        label.textColor = Theme.white
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    lazy var urlLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        label.textColor = Theme.gray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    lazy var imageView: UIImageView = {
//        let view = UIImageView()
//        view.contentMode = .scaleAspectFill
//        view.clipsToBounds = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    lazy var refreshControl: UIRefreshControl = {
//        let control = UIRefreshControl()
//        return control
//    }()
//
//    func setupView() {
//        addSubview(mainTextLabel)
//        addSubview(urlLabel)
//        addSubview(imageView)
//
//        mainTextLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
//        mainTextLabel.rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: -20).isActive = true
//        mainTextLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
//
//
//        urlLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
//        urlLabel.rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: -20).isActive = true
//        urlLabel.topAnchor.constraint(equalTo: mainTextLabel.bottomAnchor, constant: 6).isActive = true
//
//
//        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//
//    }
//
//}
