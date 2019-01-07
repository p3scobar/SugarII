//
//  CommentsController.swift
//  sugarDev
//
//  Created by Hackr on 5/17/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import Foundation
import UIKit

class CommentsController: UITableViewController, CommentInputDelegate {
    
    let commentCell = "commentCell"
    var statusId: String? {
        didSet {
            fetchData(id: statusId!)
        }
    }
    
    var comments: [Comment] = [] {
        didSet {
            reloadTable()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Comments"
        view.backgroundColor = Theme.darkBackground
        tableView.register(CommentCell.self, forCellReuseIdentifier: commentCell)
        tableView.tableFooterView = UIView()
        menu.backgroundColor = Theme.darkBackground
        tableView.keyboardDismissMode = .interactive
        tableView.separatorColor = Theme.borderColor
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func fetchData(id: String) {

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: commentCell, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.row]
        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let comment = comments[indexPath.row]
//        return estimateFrameForText(text: comment.text, fontSize: 18).height+44
        return 80
    }
    
    
    lazy var menu: CommentInputView = {
        let view = CommentInputView(frame: .zero)
        view.commentDelegate = self
        view.commentsController = self
        return view
    }()
    
    
    override var inputAccessoryView: UIView! {
        get {
            return menu
        }
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    @objc func handleSend() {
        guard let id = self.statusId, let text = menu.inputTextField.textView.text, text.count > 0 else { return }
//        StatusManager.postComment(statusId: id, text: text) { (success) in
//            self.fetchData(id: id)
//        }
        menu.inputTextField.textView.text = ""
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        //let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if notification.name == Notification.Name.UIKeyboardDidHide {
            tableView.contentInset.bottom = 0
        } else {
            tableView.contentInset.bottom = 40
            scrollToBottom(animated: true)
        }
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(010)) {
            let numberOfRows = self.tableView.numberOfRows(inSection: 0)
            let indexPath = IndexPath(row: numberOfRows-1, section: 0)
            if numberOfRows > 0 {
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard Model.shared.userId == comments[indexPath.row].userId else { return false }
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard let commentID = comments[indexPath.row].id,
            let statusID = statusId else { return }
//            StatusManager.deleteComment(statusId: statusID, commentId: commentID) { (success) in
//                if success == true {
//                    self.comments.remove(at: indexPath.row)
//                    tableView.deleteRows(at: [indexPath], with: .right)
//                }
//            }
        }
    }
    
    
    
}
