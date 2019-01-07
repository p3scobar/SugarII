//
//  CommentInputView.swift
//  sugarDev
//
//  Created by Hackr on 5/17/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import UIKit
import NextGrowingTextView

protocol CommentInputDelegate: class {
    func handleSend()
}

class CommentInputView: UIView, UITextViewDelegate {
    
    var commentDelegate: CommentInputDelegate?
    
    static let defaultHeight: CGFloat = 44
    
    weak var commentsController: CommentsController? {
        didSet {
            sendButton.addTarget(commentsController, action: #selector(commentsController?.handleSend), for: .touchUpInside)
        }
    }


    @objc func handleSendTap() {
        commentDelegate?.handleSend()
    }
    
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Theme.bold(18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Theme.gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = Theme.darkBackground
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        backgroundColor = .white
        autoresizingMask = UIViewAutoresizing.flexibleHeight
        inputTextField.isScrollEnabled = false
        inputTextField.textView.delegate = self
        
        setupView()
        
        inputTextField.delegates.didChangeHeight = { height in
            self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20+height)
            print(height)
            print(self.frame.height)
            self.frame.offsetBy(dx: 0, dy: -height)
        }
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        let height = textView.frame.height
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20+height)
        self.frame.offsetBy(dx: 0, dy: -height)
    }
    
    
    
    lazy var inputTextField: NextGrowingTextView = {
        let view = NextGrowingTextView()
        view.maxNumberOfLines = 6
        view.textView.textContainer.lineBreakMode = .byWordWrapping
        view.textView.placeholder = "Aa"
        view.textView.placeholderColor = Theme.lightGray
        view.textView.font = Theme.regular(18)
        view.textView.textColor = Theme.white
        view.textView.textContainerInset = UIEdgeInsetsMake(12, 14, 12, 80)
        view.backgroundColor = Theme.unfilled
        view.textView.keyboardAppearance = .dark
        view.layer.cornerRadius = 22
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    func setupView() {
        addSubview(sendButton)
        addSubview(inputTextField)
        
        inputTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        inputTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        
        
        sendButton.bottomAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: -4).isActive = true
        sendButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        bringSubview(toFront: sendButton)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

