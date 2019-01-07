//
//  ConfirmPaymentController.swift
//  sugarDev
//
//  Created by Hackr on 5/21/18.
//  Copyright © 2018 Stack. All rights reserved.
//


import Foundation
import UIKit
import MaterialActivityIndicator

class ConfirmPaymentController: UIViewController, UIScrollViewDelegate, ReceiptViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let cellID = "cellID"
    var type: PaymentType!
    var publicKey: String! {
        didSet {
            fetchUsername(publicKey)
        }
    }
    var username: String?
    var amount: Decimal!
    var submitted = false
    
    init(type: PaymentType, publicKey: String, amount: Decimal, username: String?) {
        self.publicKey = publicKey
        self.amount = amount
        self.type = type
        self.username = username
        super.init(nibName: nil, bundle: nil)
        if username == nil {
            self.fetchUsername(publicKey)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = header
        scrollView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = Theme.lightBackground
        tableView.register(InputTextCell.self, forCellReuseIdentifier: cellID)
        title = "Confirm \(type.rawValue.capitalized)"
        setupView()
    }
    
    lazy var header: TransactionHeader = {
        let view = TransactionHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 180))
        view.amountLabel.text = amount.rounded(3)
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height*0.5), style: .plain)
        view.backgroundColor = Theme.lightBackground
        view.separatorColor = Theme.borderColor
        view.isScrollEnabled = false
        view.tableFooterView = UIView()
        view.allowsSelection = false
        return view
    }()
    
//    lazy var card: UIView = {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height*0.6))
//        let darkBlur = UIBlurEffect(style: .dark)
//        let blurView = UIVisualEffectView(effect: darkBlur)
//        blurView.frame = view.frame
//        view.addSubview(blurView)
//        return view
//    }()
    
    
    let scrollView: UIScrollView = {
        let view = UIScrollView(frame: UIScreen.main.bounds)
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
        view.isPagingEnabled = true
//        view.decelerationRate = UIScrollViewDecelerationRateFast
        view.backgroundColor = Theme.lightBackground
        return view
    }()
    
    
    let indicator: MaterialActivityIndicatorView = {
        let view = MaterialActivityIndicatorView()
        view.color = .white
        view.lineWidth = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    let arrowView: UIImageView = {
//        let view = UIImageView()
//        let arrow = UIImage(named: "arrowUp")?.withRenderingMode(.alwaysTemplate)
//        view.image = arrow
//        view.tintColor = Theme.gray
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Swipe Up to Submit"
        label.textColor = Theme.darkText
        label.font = Theme.semibold(20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! InputTextCell
        cell.valueInput.isEnabled = false
        setupCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func setupCell(cell: InputTextCell, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "To"
            if let name = username {
                cell.valueInput.text = "@\(name)"
            }
        default:
            break
        }
    }
    
    
    func fetchUsername(_ publicKey: String) {
        UserManager.fetchUserFromPublicKey(publicKey) { [weak self] user in
            guard let username = user?.username else { return }
            self?.username = username
            self?.tableView.reloadData()
        }
    }
    
    
    func setupView() {
        view.addSubview(scrollView)
//        scrollView.addSubview(card)
        scrollView.addSubview(tableView)
        scrollView.addSubview(titleLabel)
//        scrollView.addSubview(arrowView)
        view.addSubview(indicator)
        
        indicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 60).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height*2)
        
//        arrowView.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 20).isActive = true
//        arrowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        arrowView.widthAnchor.constraint(equalToConstant: 24).isActive = true
//        arrowView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > view.frame.height*0.8 {
            indicator.startAnimating()
            self.navigationItem.hidesBackButton = true
            self.navigationItem.title = ""
            scrollView.isScrollEnabled = false
            if submitted == false {
                submitPayment()
                submitted = true
            }
        }
    }
    
    func submitPayment() {
        switch type {
        case .buy?:
            break
        case .send?:
            submitSend()
        default:
            break
        }
    }
    
    fileprivate func submitSend() {
        guard let pk = publicKey, let rounded = amount?.roundedDecimal() else {
                self.presentFailureAlert(title: "Transaction malformed", message: "We're unable to submit this transaction.")
                return
        }
        WalletManager.sendPayment(toAccountID: pk, amount: rounded) { (success) in
            if success {
                self.animateCardSuccess(amount: rounded, type: .send)
            } else {
                self.presentFailureAlert(title: "Transaction Failed", message: "Something went wrong. Please try again.")
            }
        }
    }
    
    fileprivate func animateCardSuccess(amount: Decimal, type: PaymentType) {
        indicator.stopAnimating()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        let currentDate = formatter.string(from: date)
        
        let values: [(String,String)] = [
//            ("Type","Send"),
//            ("To","@\(username.lowercased())"),
//            ("Amount", "\(amount)" + " Troy oz."),
//            ("Date", currentDate)
        ]
        
        let receiptView: ReceiptView = {
            let frame: CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width-40, height: 380)
            let view = ReceiptView(frame: frame)
            view.values = values
            view.layer.cornerRadius = 12
            view.delegate = self
            view.backgroundColor = .white
            return view
        }()
        
        receiptView.center = indicator.center
        UIView.animate(withDuration: 0.2) {
            self.view.addSubview(receiptView)
            UIDevice.vibrate()
        }
        
    }
    
    func presentFailureAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let done = UIAlertAction(title: "Done", style: .default) { (done) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(done)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

