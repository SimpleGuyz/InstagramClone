//
//  MessageApi.swift
//  Instagram
//
//  Created by alice singh on 09/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import PromiseKit
import CodableFirebase

enum ConverstionResult {
    case doesExist(String)
    case notFound
}

class MessageApi: BaseApi {
    static let conversationRef = Database.database().reference().child("Conversations")
    static let userConversationRef = Database.database().reference().child("User-Conversations")
    
    class func fetchConversationId(userId: String) -> Promise<String> {
        return readConversationId(with: userId)
            .then { convResult -> Promise<String> in
                switch convResult {
                case .doesExist(let conId):
                    return Promise(value: conId)
                case .notFound:
                    return createNewConversation(userId)
                }
            }
    }
    
    class func sendMessage(message: String, conversationId: String) -> Promise<Message> {
        return createMessageBody(message)
            .then { postBody in
                writeMessage(postBody, atConversation: conversationId)
            }.then { messId in
                readMessage(messId, conversationId: conversationId)
            }
    }
    
    class func readAllMessages(for conversationId: String) -> Promise<[Message]> {
        return conversationRef.child(conversationId).child("messages")
            .queryOrderedByKey().queryLimited(toFirst: 10)
            .observeSingleEvent()
            .then {
               handleListResponse($0)
            }
    }
    
    class func observeNewMessage(_ conversationId: String, completion: @escaping (Message?) -> Void) {
        var firstTime: Bool = true
        conversationRef.child(conversationId).child("messages")
            .queryLimited(toLast: 1)
            .observe(.childAdded) { new in
                if firstTime == true {
                    firstTime = false
                } else {
                    handleResponse(new, completion: completion)
                }
            }
    }
    
    class func opponentDetail(for conversationId: String) -> Promise<UserDetail> {
        return conversationRef.child(conversationId).child("participants")
            .queryOrderedByKey().queryLimited(toFirst: 2)
            .observeSingleEvent()
            .then(execute: resolveToOpponentId)
            .then { id in
                UsersApi.usersUserIdGET(userId: id)
            }
    }
    
    class func readConversationShort() -> Promise<[ConversationShort]> {
        guard let selfId = Auth.auth().currentUser?.uid else { return  Promise(error: ApiError.userUnauthenticated)}
        return Promise(value : [])
    }
}

// private methods
extension MessageApi {
    fileprivate class func readConversationsOppoIds() ->  Promise<[String]> {
        guard let selfId = Auth.auth().currentUser?.uid else { return  Promise(error: ApiError.userUnauthenticated)}
        userConversationRef.child(selfId)
            .queryOrderedByKey().queryLimited(toLast: 100)
            .observeSingleEvent().then { snap in
                snap.children.allObjects.map { obj in
                    if let dict = obj as? [String: Any] {
                        let first = dict.keys.first
                    }
                }
                
                //return Promise(error: ApiError.parsing)
            }
    }
    
    fileprivate class func resolveToOpponentId(_ snap: DataSnapshot) -> Promise<String> {
        guard let selfUserId = Auth.auth().currentUser?.uid else { return Promise(error: ApiError.userUnauthenticated) }
        
        guard let both = snap.value as? [String: Bool] else { return Promise(error: ApiError.parsing) }
        let ids = both.keys.map { $0 }
        return ids[0] == selfUserId ? Promise(value: ids[1]) : Promise(value: ids[0])
    }
    
    fileprivate class func readMessage(_ id: String, conversationId: String) -> Promise<Message> {
        return conversationRef.child(conversationId).child("messages").child(id)
                .observeSingleEvent()
                .then(execute: handleResponse)
    }
    
    fileprivate class func createMessageBody(_ text: String) -> Promise<PostMessage> {
        guard let selfUserId = Auth.auth().currentUser?.uid else { return Promise(error: ApiError.userUnauthenticated) }
        
        let body = PostMessage()
        body.content = text
        body.userId = selfUserId
        let currentEpoc = String(Date().timeIntervalSince1970)
        body.time = currentEpoc
        
        return Promise(value: body)
    }
    
    fileprivate class func writeMessage(_ message: PostMessage, atConversation converId: String) -> Promise<String> {
        if let data = try? FirebaseEncoder().encode(message) {
            return conversationRef.child(converId).child("messages")
                .childByAutoId()
                .setValue(value: data)
                .then { result -> Promise<String> in
                    return Promise(value: result.key)
                }
        }
        
        return Promise(error: ApiError.parsing)
    }
    
    fileprivate class func createNewConversation(_ toUserId: String) -> Promise<String> {
        guard let selfUserId = Auth.auth().currentUser?.uid else { return Promise(error: ApiError.userUnauthenticated) }
        
        return userConversationRef.child(selfUserId).child(toUserId)
            .childByAutoId().setValue(value: true)
            .then { result -> Promise<String> in
                return Promise(value: result.key)
            }.then { conversationId in
                copyConversationToOpponentNode(conId: conversationId, toUserId: toUserId)
            }.then { conversationId in
                createConversationNode(id: conversationId, toUserId: toUserId)
            }
    }
    
    fileprivate class func copyConversationToOpponentNode(conId: String, toUserId: String) -> Promise<String> {
        guard let selfUserId = Auth.auth().currentUser?.uid else { return Promise(error: ApiError.userUnauthenticated) }
        
        return userConversationRef.child(toUserId).child(selfUserId)
            .child(conId).setValue(value: true)
            .then { result in
                return Promise(value: conId)
            }
    }
    
    fileprivate class func createConversationNode(id: String, toUserId: String) -> Promise<String> {
        guard let selfUserId = Auth.auth().currentUser?.uid else { return Promise(error: ApiError.userUnauthenticated) }
        
        let dict: [String: Bool] = [
            toUserId: true,
            selfUserId: true
        ]
        return conversationRef.child(id)
            .child("participants").setValue(value: dict)
            .then { snap in
                return Promise(value: id)
        }
    }
    
    fileprivate class func readConversationId(with userId: String) -> Promise<ConverstionResult> {
        guard let selfUserId = Auth.auth().currentUser?.uid else { return Promise(error: ApiError.userUnauthenticated)}
        
        return userConversationRef.child(selfUserId).child(userId)
            .observeSingleEvent()
            .then { snap -> Promise<ConverstionResult> in
                if snap.exists() {
                    if let dict = snap.value as? [String: Bool], let conId = dict.keys.first {
                        return Promise(value: .doesExist(conId))
                    }
                }
                
                return Promise(value: .notFound)
        }
    }
}
