//
//  NewProfileController.swift
//  sugarDev
//
//  Created by Hackr on 5/17/18.
//  Copyright © 2018 Stack. All rights reserved.
//
//

import UIKit
import CoreImage
import Firebase
//import DeckTransition

class ProfileController: UITableViewController {

    private let cellId = "cellId"

    var user: User? {
        didSet {
            headerView.user = user
            blocked = userBlocked()
            
            if let bio = user!.bio {
                let height = estimateFrameForText(text: bio, fontSize: 20).height
                headerView.frame.size.height += height
            }

            if user?.id! == Model.shared.userId {
                headerView.messageButton.isEnabled = false
                headerView.favoriteButton.isEnabled = false
                headerView.payButton.isEnabled = false
            }
        }
    }

    var username: String? {
        didSet {
            UserManager.fetchUser(withUsername: username!) { (user) in
                self.user = user
            }
        }
    }
    
    convenience init(userId: String) {
        self.init()
        UserManager.fetchUser(userId: userId) { (user) in
            self.user = user
        }
    }

    var favorited: Bool = false
    var blocked: Bool = false

    lazy var headerView: ProfileHeaderView = {
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 280)
        let view = ProfileHeaderView(frame: frame)
        view.profileDelegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = headerView
        headerView.user = user
        title = "User"
        extendedLayoutIncludesOpaqueBars = true
        view.backgroundColor = Theme.lightBackground
        tableView.separatorColor = Theme.borderColor
        tableView.backgroundColor = Theme.lightBackground
        tableView.tableFooterView = UIView()

        tableView.showsVerticalScrollIndicator = false
        checkIfFavorite()
        if user?.id != Model.shared.userId {
            let iconMore = UIImage(named: "more")?.withRenderingMode(.alwaysTemplate)
            self.navigationItem.rightBarButtonItem  = UIBarButtonItem(image: iconMore, style: .done, target: self, action: #selector(handleMoreTap))
        }
    }


    func checkIfFavorite() {
        guard let id = self.user?.id else { return }
        UserManager.isInFavorites(userId: id) { (favorite) in
            self.favorited = favorite
            self.headerView.favorited = favorite
        }
    }

    
    @objc func handleMessageTap() {
        let uid = Model.shared.userId
        guard let toId = user?.id else { return }
        let ids = [uid, toId]
        let chatId = generateChatId(ids: ids)
        let vc = ChatController(chatId: chatId, toId: toId, title: user?.name ?? "", image: user?.photo ?? "")
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }


    func handleFavoriteTap() {
        guard let id = self.user?.id else { return }
        UserManager.favorite(userId: id) { (favorite) in
            self.favorited = favorite
            self.headerView.favorited = favorite
        }
    }

    func handlePay() {
        guard let publicKey = user?.publicKey else { return }
        let vc = AmountController(type: .send, publicKey: publicKey, username: username)
        vc.username = self.user?.username
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }


    func blockUser() {
        guard let userId = self.user?.id else { return }
//        UserManager.block(user: userId, completion: { (blocked) in
//            self.blocked = blocked
//            if blocked == true {
//
//            }
//        })
    }

    func userBlocked() -> Bool {
//        guard let id = user?.id, let userId = user?.id else { return true }
//        let blockedUsers = Model.shared.blocked ?? [:]
//        let userBlocks = user?.blocked ?? [:]
//        if blockedUsers[userId] == true || userBlocks[id] == true {
//            return true
//        } else {
//            return false
//        }
        return false
    }

    @objc func handleMoreTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .black
        var buttonTitle = "Block"
        if blocked { buttonTitle = "Unblock" }
        let block = UIAlertAction(title: buttonTitle, style: .destructive) { (blocked) in
            self.blockUser()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(block)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }



    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        return cell
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
