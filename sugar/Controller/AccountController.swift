//
//  AccountController.swift
//  devberg
//
//  Created by Hackr on 10/3/17.
//  Copyright © 2017 Hackr. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import Photos

class AccountController: UITableViewController, MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, MFMessageComposeViewControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    let userCell = "userCell"
    let standardCell = "standardCell"
    
    lazy var header: AccountHeader = {
        let view = AccountHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        header.delegate = self
        header.tap.delegate = self
        
        tableView.backgroundColor = Theme.lightBackground
        tableView.tableHeaderView = header
        tableView.separatorColor = Theme.borderColor
        tableView.register(UserCell.self, forCellReuseIdentifier: userCell)
        tableView.register(StandardCell.self, forCellReuseIdentifier: standardCell)
        tableView.tableFooterView = UIView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .blackTranslucent
        let tap = UITapGestureRecognizer(target: self, action: #selector(pushProfile))
        header.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        header.usernameLabel.text = "@\(Model.shared.username)"
        header.nameLabel.text = Model.shared.name
        header.setupNameAndProfileImage()
    }
    
    func photoPermission() -> Bool {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        var authorized: Bool = false
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
            authorized = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                print("status is \(status)")
                if status == PHAuthorizationStatus.authorized {
                    authorized = true
                }
            })
        case .restricted:
            print("User do not have access to photo album.")
            authorized = false
        case .denied:
            print("User has denied the permission.")
            authorized =  false
        }
        return authorized
    }

    
    @objc func pushProfile() {
        let vc = ProfileController(userId: Model.shared.userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: standardCell, for: indexPath) as! StandardCell
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                cell.textLabel?.text = "Settings"
            case (0, 1):
                cell.textLabel?.text = "Invite Friends"
            case (1, 0):
                cell.textLabel?.text = "Passphrase"
            case (2, 0):
                cell.textLabel?.text = "Sign out"
            default:
                break
            }
            return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func handleEditButtonTap() {
        let vc = EditProfileController(style: .grouped)
        vc.accountController = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case(0,0):
            pushNotificationController()
        case (0, 1):
            presentInviteController()
        case (1,0):
            pushMnemonicController()
        case (2,0):
            presentSignOutAlert()
        default:
            return
        }
    }
    
    func pushMnemonicController() {
        let vc = MnemonicController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func pushSecurityController() {
        let vc = SecurityController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func presentInviteController() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = Theme.black
        let message = UIAlertAction(title: "SMS", style: .default) { (mail) in
            if MFMessageComposeViewController.canSendText() {
                self.presentMessageController()
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(message)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func presentMessageController() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.body = "Hey, you should download Sugar. Here's the link: sugar.am/ios"
        self.present(composeVC, animated: true, completion: nil)
    }
    
    
    func pushNotificationController() {
        let vc = NotificationsController(style: .grouped)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func presentSignOutAlert() {
        let alert = UIAlertController(title: "Have you secured your recovery phrase?", message: "Without this you will not be able to recover your account or sign back in.", preferredStyle: .actionSheet)
        alert.view.tintColor = Theme.black
        let signOut = UIAlertAction(title: "Sign Out", style: .destructive) { (_) in
            self.handleLogout()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(signOut)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleLogout() {
        do {
            try Auth.auth().signOut()
        }   catch let logoutError {
            print(logoutError)
        }
        UserManager.signOut()
        let vc = WelcomeController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true)
        self.tabBarController?.selectedIndex = 0
    }
    
    
    func pushProfileController() {
        let vc = ProfileController(userId: Model.shared.userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
//    func presentMailController() {
//        if !MFMailComposeViewController.canSendMail() {
//            let alert = UIAlertController(title: "Email Unavailable", message: "Please setup email on your iPhone", preferredStyle: .alert)
//            let doneButton = UIAlertAction(title: "Done", style: .cancel, handler: nil)
//            alert.addAction(doneButton)
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//        let composeVC = MFMailComposeViewController()
//        composeVC.isModalInPopover = true
//        composeVC.mailComposeDelegate = self
//        let body = "Hey, you should download Sugar. Here's the link: sugar.am/ios"
//        composeVC.setMessageBody(body, isHTML: false)
//        composeVC.modalPresentationStyle = .none
//        present(composeVC, animated: true, completion: nil)
//    }
    
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
    
    func handleEditProfilePic() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let picker = UIAlertAction(title: "Camera Roll", style: .default) { (alert) in
            self.presentImagePickerController()
        }
        let pixel = UIAlertAction(title: "New Pixel Photo", style: .default) { (a) in
            self.generateNewPixel()
        }
        let done = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alert.addAction(picker)
        alert.addAction(pixel)
        alert.addAction(done)
        present(alert, animated: true, completion: nil)
    }
    
    func generateNewPixel() {
        let pixelView = PixelView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        let image = UIImage.imageWithView(pixelView)
        header.profileImage.image = image
        UserManager.updateProfilePic(image: image)
    }
    
    
    func presentImagePickerController() {
        if photoPermission() {
            let vc = UIImagePickerController()
            vc.allowsEditing = true
            vc.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
//
//    private func uploadToFirebaseStorageUsingImage(image: UIImage) {
//        let imageName = NSUUID().uuidString
//        let ref = Storage.storage().reference().child("message_images").child(imageName)
//        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
//            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//                if error != nil {
//                    print("Failed to upload image:", error!)
//                    return
//                }
//                if let imageUrl = metadata?.downloadURL()?.absoluteString {
//
//                }
//            })
//        }
//    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        if let selectedImage = selectedImageFromPicker {
            UserManager.updateProfilePic(image: selectedImage)
            header.profileImage.image = selectedImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }

    
}
