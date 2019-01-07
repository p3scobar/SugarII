//
//  ComposeToolbar.swift
//  sugarDev
//
//  Created by Hackr on 10/20/18.
//  Copyright © 2018 Stack. All rights reserved.
//

protocol ComposeDelegate: class {
    func handleSend()
    func handlePhotoIconTap()
}

import UIKit

class ComposeToolbar: UIToolbar {
    
    var inputDelegate: ComposeDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        isTranslucent = false
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        setItems([photoButton, flexibleSpace], animated: true)
        tintColor = .black
    }
    
    lazy var photoButton: UIBarButtonItem = {
        let photo = UIImage(named: "photo3")?.withRenderingMode(.alwaysTemplate)
        let button = UIBarButtonItem(image: photo, style: .done, target: self, action: #selector(handlePhoto))
        return button
    }()
    
    //    lazy var sendButton: UIBarButtonItem = {
    //        let button = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.done, target: self, action: #selector(handleSend))
    //        button.setTitlePositionAdjustment(UIOffsetMake(0, 10), for: .default)
    //        return button
    //    }()
    
    //    @objc func handleSend() {
    //        inputDelegate?.handleSend()
    //    }
    
    @objc func handlePhoto() {
        inputDelegate?.handlePhotoIconTap()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

