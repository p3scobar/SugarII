//
//  AmountController.swift
//  sugarDev
//
//  Created by Hackr on 4/23/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import UIKit
import Firebase
//import MPNumericTextField

class AmountController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    var type: PaymentType!
    var amount: Decimal = 0.0
    var publicKey: String?
    var username: String?
    
    init(type: PaymentType, publicKey: String?, username: String?) {
        self.type = type
        self.publicKey = publicKey
        self.username = username
        super.init(nibName: nil, bundle: nil)
        setupLabels()
    }
    
    func setupLabels() {
        switch type {
        case .buy?:
            captionLabel.text = "USD"
        case .send?:
            captionLabel.text = "USD"
        default:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = type.rawValue.capitalized
        view.backgroundColor = Theme.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmit))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        setupView()
    }
    

    func handleError(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let doneButton = UIAlertAction(title: "Done", style: .default, handler: nil)
        alert.addAction(doneButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleSubmit() {
        switch type {
        case .send?:
            handleSend()
        case .buy?:
            handleBuy()
        default:
            break
        }
    }
    
    func handleBuy() {
        
    }
    
    func handleSend() {
        guard let accountID = publicKey else { return }
        let rounded = amount.roundedDecimal()
        let vc = ConfirmPaymentController(type: .send, publicKey: accountID, amount: rounded, username: username)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        amountInput.becomeFirstResponder()
    }
    
    
    @objc func textFieldDidChange(textField: UITextField){
        formatInput()
    }
    
    func formatInput() {
        guard amountInput.decimal <= amountInput.maximum else {
            amountInput.text = amountInput.lastValue
            return
        }
        amountInput.lastValue = Formatter.currency.string(for: amountInput.decimal) ?? ""
        amountInput.text = amountInput.lastValue
        amount = amountInput.decimal
    }
    
    
    override var inputAccessoryView: UIView? {
        return confirmButton
    }
    
    
    lazy var confirmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        return button
    }()
    
    
    var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .decimal
        return formatter
    }()
//
//    lazy var amountInput: UITextField = {
//        let field = UITextField()
//        field.textAlignment = .center
//        field.textColor = Theme.darkText
//        field.attributedPlaceholder = NSAttributedString(string: "0.000", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
//        field.adjustsFontSizeToFitWidth = true
//        field.keyboardType = .decimalPad
//        field.font = Theme.bold(36)
//        field.borderStyle = UITextBorderStyle.none
//        field.delegate = self
//        field.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
//        field.translatesAutoresizingMaskIntoConstraints = false
//        return field
//    }()
    
    
    lazy var amountInput: CurrencyField = {
        let field = CurrencyField()
        field.textAlignment = .center
        field.attributedPlaceholder = NSAttributedString(string: "0.000", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        field.adjustsFontSizeToFitWidth = true
        field.keyboardType = .decimalPad
        field.keyboardAppearance = UIKeyboardAppearance.light
        field.font = Theme.bold(36)
        field.borderStyle = UITextBorderStyle.none
        field.delegate = self
        field.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var captionLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.font = Theme.medium(24)
        view.textColor = Theme.gray
        view.text = "USD"
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    func setupView() {
        view.addSubview(amountInput)
        view.addSubview(captionLabel)
        
        amountInput.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        amountInput.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        let offset = view.frame.height/4
        amountInput.centerYAnchor.constraint(equalTo: view.topAnchor, constant: offset).isActive = true
        amountInput.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        captionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        captionLabel.topAnchor.constraint(equalTo: amountInput.bottomAnchor, constant: 0).isActive = true
        captionLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
}
