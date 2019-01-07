//
//  UserManager.swift
//  devberg
//
//  Created by Hackr on 4/1/18.
//  Copyright © 2018 Hackr. All rights reserved.
//

import Foundation
import Firebase
import stellarsdk

struct UserManager {
    
    static func signup(username: String, completion: @escaping (Bool) -> Swift.Void) {
        let email = "\(username)@email.com"
        KeychainHelper.mnemonic = Wallet.generate12WordMnemonic()
        let password = KeychainHelper.mnemonic.sha256()
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let error = err {
                print(error.localizedDescription)
                completion(false)
            } else {
                let id = result!.user.uid
                let values: [String:Any] = ["id":id,
                                            "email":email,
                                            "name":username.capitalized,
                                            "username":username,
                                            "publicKey":KeychainHelper.publicKey]
                
                let ref = db.collection("users").document(id)
                ref.setData(values)
                Model.shared.userId = id
                Model.shared.name = username.capitalized
                Model.shared.soundsEnabled = true
                completion(true)
            }
        }
    }

    
    static func fetchUser(userId: String, completion: @escaping (User) -> Swift.Void) {
        let ref = db.collection("users").document(userId)
        ref.getDocument { (document, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let data = document?.data() {
                    let user = User(dictionary: data)
                    completion(user)
                }
            }
        }
    }

    
    static func fetchNotificationKey(forUser userId: String, completion: @escaping (String?) -> Swift.Void) {
        let ref = db.collection("users").document(userId)
        ref.getDocument { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                guard let data = snap!.data(),
                    let key = data["notificationKey"] as? String else {
                        completion(nil)
                        return
                }
                completion(key)
            }
        }
    }
    
    
    /// MARK: FETCH MULTIPLE USERS
    
    static func fetchUsers(query username: String, completion: @escaping ([User]) -> Swift.Void) {
        var users: [User] = []
        let blocked = Model.shared.blocked ?? [:]
        let ref = db.collection("users").whereField("username", isGreaterThanOrEqualTo: username)
        ref.getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            for item in documents {
                let user = User(dictionary: item.data())
                if let userId = user.id {
                    if blocked[userId] != true {
                        users.append(user)
                    } else {
                        print("\(user.name ?? "") is blocked.")
                    }
                }
            }
            completion(users)
        }
    }

    /// MARK: FETCH USER
    
    static func fetchUser(withUsername username: String, completion: @escaping (User?) -> Swift.Void) {
        let formattedUsername = username.lowercased()
        db.collection("users").whereField("username", isEqualTo: formattedUsername)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(nil)
                } else {
                    for document in querySnapshot!.documents {
                        let user = User(dictionary: document.data())
                        completion(user)
                    }
                }
        }
    }
    
    
    static func fetchAllUsers(completion: @escaping ([User]) -> Swift.Void) {
        var users = [User]()
        let ref = db.collection("users")
        ref.getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else { return }
            for item in documents {
                let user = User(dictionary: item.data())
                if !blockingRelationship(user: user) {
                    users.append(user)
                    completion(users)
                }
            }
        }
    }
    

    static func blockingRelationship(user: User) -> Bool {
        guard let id0 = Auth.auth().currentUser?.uid, let id1 = user.id else { return false }
        let blocking = Model.shared.blocked?[id1] ?? false
        let blockedBy = user.blocked?[id0] ?? false
        if blocking || blockedBy == true {
            return true
        } else {
            return false
        }
    }
    
    static func login(mnemonic: String, completion: @escaping (Bool) -> Swift.Void) {
        let keyPair = try! Wallet.createKeyPair(mnemonic: mnemonic, passphrase: nil, index: 0)
        let publicKey = keyPair.publicKey.accountId
        fetchUserFromPublicKey(publicKey) { (fetchedUser) in
            guard let user = fetchedUser,
            let username = user.username else {
                completion(false)
                return
            }
            setupCurrentUser(user: user)
            let email = "\(username)@email.com"
            Auth.auth().signIn(withEmail: email, password: mnemonic.sha256()) { (firUser, error) in
                if let err = error {
                    print(err.localizedDescription)
                    completion(false)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                    KeychainHelper.mnemonic = mnemonic
                    KeychainHelper.publicKey = publicKey
                    KeychainHelper.privateSeed = keyPair.secretSeed
                    completion(true)
                }
            }
        }
    }

    static func login(username: String, password: String, completion: @escaping (User?) -> Swift.Void) {
        fetchUser(withUsername: username) { (fetchedUser) in
            guard let user = fetchedUser else {
                completion(nil)
                return
            }
            setupCurrentUser(user: user)
            let email = "\(username)@email.com"
            Auth.auth().signIn(withEmail: email, password: password.sha256()) { (firUser, error) in
                if let err = error {
                    print(err.localizedDescription)
                    completion(nil)
                } else {
                    KeychainHelper.mnemonic = password
                    completion(user)
                }
            }
        }
    }
    
    static func setupCurrentUser(user: User) {
            Model.shared.userId = user.id ?? ""
            Model.shared.name = user.name ?? ""
            Model.shared.username = user.username ?? ""
            Model.shared.profileImage = user.photo ?? ""
            Model.shared.email = user.email ?? ""
            Model.shared.publicKey = user.publicKey ?? ""
    }
    
    
    static func usernameAvailable(username: String, completion: @escaping (Bool) -> Swift.Void) {
        let ref = db.collection("users").whereField("username", isEqualTo: username)
        ref.getDocuments { (snap, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(false)
            } else {
                if snap!.documents.count > 0 {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    
    static func updateUserInfo(values: [String:Any]) {
        guard let id = Auth.auth().currentUser?.uid else { return }
        let ref = db.collection("users").document(id)
        ref.updateData(values) { err in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    print("user data updated")
                }
        }
    }
    
    
//    static func checkIfFollowing(userId: String, completion: @escaping (Bool) -> Swift.Void) {
//        guard let id = Auth.auth().currentUser?.uid else { return }
//        let ref = db.collection("users").document(id).collection("following").document(userId)
//        ref.getDocument { (snap, err) in
//            if let following = snap?.get(userId) as? Bool {
//                if following {
//                    completion(true)
//                } else {
//                    completion(false)
//                }
//            } else {
//                completion(false)
//            }
//        }
//    }
  
    
//
//    static func follow(userId: String, following: Bool, notificationKey: String, completion: @escaping (Bool) -> Swift.Void) {
//
//        guard let id = Auth.auth().currentUser?.uid else { return }
//        let batch = db.batch()
//
//        let followingRef = db.collection("users").document(id).collection("following").document(userId)
//        batch.setData([userId:!following], forDocument: followingRef, merge: true)
//
//        let followerRef = db.collection("users").document(userId).collection("followers").document(id)
//        batch.setData([id:!following], forDocument: followerRef, merge: true)
//
//        batch.commit() { err in
//            if let error = err {
//                print(error.localizedDescription)
//            } else {
//                completion(!following)
//                if following == false {
//                    sendFollowNotification(userId: userId, notificationKey: notificationKey)
//                }
//            }
//        }
//    }
    
    
//    static func sendFollowNotification(userId: String, notificationKey: String) {
//        fetchNotificationKey(forUser: userId) { (key) in
//            guard key != nil else { return }
//            
//            /// Determine if notification exists
//            guard let uid = Auth.auth().currentUser?.uid else { return }
//            let ref = db.collection("notifications")
//                .whereField("fromId", isEqualTo: uid)
//                .whereField("type", isEqualTo: "follow")
//                .whereField("toId", isEqualTo: userId)
//            ref.getDocuments(completion: { (snap, err) in
//                if let error = err {
//                    print(error.localizedDescription)
//                } else {
//                    if snap?.documents.count == 0 {
//                        ActivityManager.pushNotification(keys: [key!], toId: userId, message: "Started following you.")
//                        
//                        ActivityManager.newActivity_Follow(toId: userId)
//                    }
//                }
//            })
//        }
//    }
    
    
    static func updateProfilePic(image: UIImage) {
        uploadImageToStorage(image: image) { (url) in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let ref = db.collection("users").document(uid)
            ref.updateData(["photo":url]) { err in
                if let error = err {
                    print(error.localizedDescription)
                } else {
                    Model.shared.profileImage = url
                }
            }
        }
    }
    
    
    static func uploadImageToStorage(image: UIImage, completion: @escaping (String) -> Swift.Void) {
        let imageName = UUID.init().uuidString
        let ref = Storage.storage().reference().child("profiles").child(imageName)
        if let uploadData = UIImageJPEGRepresentation(image, 0.4) {
            ref.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                if error != nil {
                    print("failed to upload image:", error!)
                    return
                }
                ref.downloadURL(completion: { (url, err) in
                    if let link = url?.absoluteString {
                        completion(link)
                    }
                })
            })
        }
    }
    
    
    static func block(user userId: String, completion: @escaping (Bool) -> Swift.Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = db.collection("users").document(uid)
        db.runTransaction({ (transaction, err) in
            let doc: DocumentSnapshot
            do {
                try doc = transaction.getDocument(ref)
                let blocked = doc.data()?["blocked"] as? [String:Bool] ?? [:]
                if blocked[userId] == true {
                    let data: [String:Any] = [
                        "blocked.\(userId)": false
                    ]
                    transaction.updateData(data, forDocument: ref)
                    Model.shared.blocked?[userId] = false
                    completion(false)
                } else {
                    let data: [String:Any] = [
                        "blocked.\(userId)": true
                    ]
                    transaction.updateData(data, forDocument: ref)
                    Model.shared.blocked?[userId] = true
                    completion(true)
                }
            } catch {
                completion(false)
            }
            return nil
        }) { (object, error) in
            
        }
    }
    
    
    static func saveNotificationKey(key: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = db.collection("users").document(uid)
        ref.updateData(["notificationKey":key]) { (err) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                UserDefaults.standard.set(key, forKey: "notificationKey")
            }
        }
    }
    
    
    private static func reAuthenticate(email: String, password: String, completion: @escaping (Bool, String?) -> Swift.Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        let user = Auth.auth().currentUser
        user?.reauthenticate(with: credential, completion: { (err) in
            if let error = err {
                print(error.localizedDescription)
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        })
    }
    
    
    
    static func updateEmail(email: String, newEmail: String, password: String, completion: @escaping (Bool, String?) -> Swift.Void) {
        reAuthenticate(email: email, password: password) { (authenticated, message) in
            if !authenticated && message != nil {
                completion(false, message!)
                return
            } else if authenticated {
                Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (err) in
                    if let error = err {
                        print(error.localizedDescription)
                        completion(false, error.localizedDescription)
                    } else {
                        updateUserInfo(values: ["email":newEmail])
                        Model.shared.email = newEmail
                        completion(true, nil)
                    }
                })
            }
        }
    }
    
    
    static func updatePassword(email: String, password: String, newPassword: String, completion: @escaping (Bool, String?) -> Swift.Void) {
        reAuthenticate(email: email, password: password) { (authenticated, message) in
            if !authenticated && message != nil {
                completion(false, message)
                return
        } else if authenticated {
                Auth.auth().currentUser?.updatePassword(to: password, completion: { (err) in
                    if let error = err {
                        print(error.localizedDescription)
                        completion(false, error.localizedDescription)
                    } else {
                        completion(true, nil)
                    }
                })
            }
        }
    }
    
    
//    static func favorite(userId: String, completion: @escaping (Bool) -> Void) {
//        var favorite: Bool = false
//        let id = Model.shared.userId
//        let ref = db.collection("users").document(id).collection("favorites").document(userId)
//        db.runTransaction({ (transaction, errorPointer) -> Any? in
//            let doc: DocumentSnapshot
//            do {
//                try doc = transaction.getDocument(ref)
//            } catch {
//                return nil
//            }
//
//            let fav = doc.data()?["favorite"] as? Bool ?? false
//            favorite = fav
//            transaction.updateData(["favorite":!fav], forDocument: ref)
//
//            return nil
//        }) { (obj, err) in
//            DispatchQueue.main.async {
//                completion(favorite)
//            }
//        }
//    }
    
    
    static func favorite(userId: String, completion: @escaping (Bool) -> Void) {
        let id = Model.shared.userId
        let ref = db.collection("users").document(id).collection("favorites").document(id)
        ref.getDocument { (snap, err) in
            if let error = err {
                print(error)
                completion(false)
            } else {
                let favorite = snap!.data()?[userId] as? Bool ?? false
                ref.setData([userId:!favorite], merge: true)
                completion(!favorite)
            }
        }
    }
    
    
    static func fetchFavorites(completion: @escaping ([User]?) -> Void) {
        var users: [User] = []
        let dispatchGroup = DispatchGroup()
        let uid = Model.shared.userId
        let ref = db.collection("users").document(uid).collection("favorites").document(uid)
        ref.getDocument { (snap, err) in
            if let error = err {
                print(error.localizedDescription)
                completion(nil)
            } else {
                if let data = snap?.data() as? [String:Bool], snap!.exists {
                    Model.shared.favorites = data
                    var ids: [String] = []
                    for (id,fav) in data {
                        if fav == true {
                            ids.append(id)
                            dispatchGroup.enter()
                            UserManager.fetchUser(userId: id, completion: { (user) in
                                users.append(user)
                                dispatchGroup.leave()
                            })
                        }
                    }
                    dispatchGroup.notify(queue: .main, execute: {
                        completion(users)
                    })
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    
    static func fetchUserFromPublicKey(_ publicKey: String, completion: @escaping (User?) -> Void) {
        let ref = db.collection("users").whereField("publicKey", isEqualTo: publicKey)
        ref.getDocuments { (snap, error) in
            if let err = error {
                print(err.localizedDescription)
                completion(nil)
            } else {
                guard let data = snap?.documents.first?.data() else {
                        print("No user fetched from public key")
                        completion(nil)
                        return
                }
                completion(User(dictionary: data))
            }
        }
    }
    
    
    static func isInFavorites(userId: String, completion: @escaping (Bool) -> Swift.Void) {
        if Model.shared.favorites[userId] == true {
            completion(true)
        } else {
            completion(false)
        }
    }

    
    static func signOut() {
        Model.shared.userId = ""
        Model.shared.name = ""
        Model.shared.username = ""
        Model.shared.profileImage = ""
        Model.shared.email = ""
        Model.shared.bio = ""
        dbRealtime.removeAllObservers()
        ChatService.chatsDictionary = [:]
        Model.shared.favorites = [:]
    }
    
}
