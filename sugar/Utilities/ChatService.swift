//
//  ChatService.swift
//  sugarDev
//
//  Created by Hackr on 5/28/18.
//  Copyright © 2018 Stack. All rights reserved.
//

import Foundation
import Firebase

struct ChatService {
    
    static var chatsDictionary: [String:Chat] = [:] {
        didSet {
            let convos = Array(chatsDictionary.values)
            let chatsSorted = convos.sorted { $0.lastMessageSent ?? 0.0 > $1.lastMessageSent ?? 0.0 }
            chats?(chatsSorted)
        }
    }
    
    static var chats: (([Chat]) -> Void)?
    
    
    static func fetchChats() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        let userChatsRef = dbRealtime.child("userChats").child(id)
        let chatRef = dbRealtime.child("chats")

        userChatsRef.observe(.value) { (snap) in
            guard let chatDict = snap.value as? [String:Bool] else { return }
            chatDict.forEach({ (key, _)  in
                chatRef.child(key).observe(.value, with: { (snap) in
                    if let chat = Chat(snapshot: snap) {
                        chatsDictionary.updateValue(chat, forKey: snap.key)
                    }
                })
            })
        }
        
//        userChatsRef.observe(.childAdded) { (snap) in
//            chatRef.child(snap.key).observe(.value, with: { (snap) in
//                if let chat = Chat(snapshot: snap) {
//                    chatsDictionary.updateValue(chat, forKey: snap.key)
//                }
//            })
//        }
    }
    
    
    static func fetchChat(chatId: String, completion: @escaping (Chat?) -> Swift.Void) {
        let ref = dbRealtime.child("chats").child(chatId)
        ref.observeSingleEvent(of: .value) { (snap) in
            guard let chat = Chat(snapshot: snap) else {
                return completion(nil)
            }
            completion(chat)
        }
    }
    


    static func observeMessages(chatId: String, completion: @escaping (Message?) -> Void) {
        let ref = dbRealtime.child("messages").child(chatId)
        ref.observe(.childAdded, with: { (snap) in
            guard let message = Message(snapshot: snap) else {
                return completion(nil)
            }
            completion(message)
        })
    }
    
    static func removeObserverForChat(chatId: String) {
        let ref = dbRealtime.child("messages").child(chatId)
        ref.removeAllObservers()
    }
    
    
    static func sendMessage(chat: Chat, properties: [String: Any]) {
        let userId = Model.shared.userId
        let userImage = Model.shared.profileImage
        let name = Model.shared.name
        let username = Model.shared.username
        let messageId: String = UUID.init().uuidString
        let messageRef = dbRealtime.child("messages").child(chat.id).child(messageId)
        let timestamp = ServerValue.timestamp()
        var messageValues = ["id": messageId,
                             "userId": userId,
                             "timestamp": timestamp,
                             "userImage": userImage,
                             "name": name,
                             "username": username
                             ] as [String : Any]
        var chatValues = ["fromId": userId,
                          "timestamp": timestamp,
                          "id": chat.id,
                          "isGroup":chat.isGroup] as [String : Any]
        if let lastMessage = properties["text"] as? String {
            chatValues["lastMessage"] = lastMessage
        }
        properties.forEach({messageValues[$0] = $1})
        messageRef.updateChildValues(messageValues) { (err, ref) in
            if let error = err {
                print(error.localizedDescription)
            } else {
                updateChat(chat: chat, values: chatValues)
            }
        }
    }
    
    fileprivate static func updateChat(chat: Chat, values:[String:Any]) {
        let chatRef = dbRealtime.child("chats").child(chat.id)
        chatRef.updateChildValues(values)
        chatRef.child("users").setValue(chat.userIds)
        chat.userIds.forEach { (id) in
            dbRealtime.child("userChats").child(id).child(chat.id).setValue(true)
            if !chat.isGroup, id != Model.shared.userId {
                ActivityManager.pushNotification(toId: id, message: "Sent you a message.")
            }
        }
    }
    
    
    static func deleteChat(chatId: String) {
        let userId = Model.shared.userId
        let ref = dbRealtime.child("userChats").child(userId).child(chatId)
        ref.removeValue()
        chatsDictionary[chatId] = nil
    }
    
    
}




