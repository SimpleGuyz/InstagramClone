//
//  UsersApi.swift
//  Instagram
//
//  Created by Kaushal on 05/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CodableFirebase
import FirebaseAuth
import PromiseKit 

enum ApiError: Error {
    case userUnauthenticated
    case parsing
    case unknown
}

extension DatabaseReference {
//    func singleEventPromise<T>() -> Promise<T> {
//        return Promise { fullfilled, resolved in
//            self.observeSingleEvent(of: .value) { (snap) in
//                BaseApi.handleResponse<T>(snap)
//                    .then(execute: fullfilled)
//                    .catch(execute: resolved)
//            }
//        }
//
//    }
}

class UsersApi: BaseApi {
    static let userRef = Database.database().reference().child("User")
    static let feedRef = Database.database().reference().child("Feed")
    static let userQuoteRef = Database.database().reference().child("UserQuote")
    static let followerRef = Database.database().reference().child("Follower")
    static let followingRef = Database.database().reference().child("Following")
    static let followerCountRef = Database.database().reference().child("FollowerCount")
    static let followingCountRef = Database.database().reference().child("FollowingCount")
    
    
    class func usersUserIdGET(userId: String, completion: @escaping (UserDetail?) -> Void) {
        userRef.child(userId).observeSingleEvent(of: .value) { handleResponse($0, completion: completion) }
    }
    
    
    class func usersUserIdGET(userId: String) -> Promise<UserDetail> {
        return userRef.child(userId).observeSingleEvent().then(execute: handleResponse)
    }

    class func usersSelfGET(completion: @escaping (UserDetail?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: Unauthenticated user")
            completion(nil)
            return
        }
        
        userRef.child(userId).observeSingleEvent(of: .value) { handleResponse($0, completion: completion) }
    }
    
    class func userSelfObserve(completion: @escaping (UserDetail?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: Unauthenticated user")
            completion(nil)
            return
        }
        
        userRef.child(userId).observe(.value) { handleResponse($0, completion: completion) }
    }
    
    class func userSelfPUT(_ body: UserUpdate, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return completion(ApiError.userUnauthenticated) }
        
        guard let data = try? FirebaseEncoder().encode(body) else { return completion(ApiError.parsing) }
        
        userRef.child(userId).updateChildValues(data as! [AnyHashable : Any]) { (error, dbRef) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    class func userSelfPOST(_ body: PostUser, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return completion(ApiError.userUnauthenticated) }
        guard let data = try? FirebaseEncoder().encode(body) else { return completion(ApiError.parsing) }
        
        userRef.child(userId).setValue(data) { (error, dbref) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
    
    class func userSelfAvatarPUT(_ url: URL) -> Promise<Void> {
        guard let userId = Auth.auth().currentUser?.uid else { return Promise(error: ApiError.userUnauthenticated) }
        
        return userRef.child(userId).child("avatarURL").setValueIgnoreResult(url.absoluteString)
    }
    
    class func userSelfQuotesObserver(completion: @escaping (Quote?) -> Void) {
        guard let myUserId = Auth.auth().currentUser?.uid else { return }
        userQuotesObserver(userid: myUserId, completion: completion)
    }
    
    class func userQuotesObserver(userid: String, completion: @escaping (Quote?) -> Void) {
        userQuoteRef.child(userid).observe(.childAdded) { (snap) in
            let quoteId = snap.key
            ItemsApi.itemByQuoteId(quoteId: quoteId, completion: completion)
        }
    }
    
    class func userSelfQuoteDelete(id: String, completion: @escaping (Error?) -> ()) {
        feedRef.child(id).removeValue { (error, dbRef) in
            completion(error)
        }
    }
    
    class func UserSelfQuotePUT(_ id: String, _ body: QuoteUpdate, completion: @escaping (Error?) -> Void) {
        guard let data = try? FirebaseEncoder().encode(body) else { return }
        feedRef.child(id).updateChildValues(data as! [AnyHashable: Any]) { (error, dbRef) in
            completion(error)
        }
    }
    
    class func allUserGET(_ completion: @escaping ([UserDetail]?) -> Void ) {
        userRef.observeSingleEvent(of: .value) { (snap) in
            let dataArray = snap.children.allObjects
            let models: [UserDetail?] = dataArray.map { data in
                if let datasnap = data as? DataSnapshot {
                    let model = try? FirebaseDecoder().decode(UserDetail.self, from: datasnap.value as Any)
                    model?.id = datasnap.key
                    return model
                }
                return nil
            }
            completion(models.flatMap { $0 })
        }
    }
    
    class func allFollowersGET(_ id: String, completion: ([UserProfile]?)) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
          followerRef.child(userId).observe(.childAdded) { (snapshot) in
        }
    }
    
    class func userFollowPOST(userId: String) {
        guard let selfUserId = Auth.auth().currentUser?.uid else { return }
        followingRef.child(selfUserId).child(userId).setValue(true)
        followerRef.child(userId).child(selfUserId).setValue(true)
        
        followingCountRef.child(selfUserId).child("count").runTransactionBlock { (mutableSnap) -> TransactionResult in
            if let count = mutableSnap.value as? Int {
                mutableSnap.value = count + 1
                return TransactionResult.success(withValue: mutableSnap)
            }
            
            mutableSnap.value = 1
            return TransactionResult.success(withValue: mutableSnap)
        }
        
        followerCountRef.child(userId).child("count").runTransactionBlock { (mutableSnap) -> TransactionResult in
            if let count = mutableSnap.value as? Int {
                mutableSnap.value = count + 1
                return TransactionResult.success(withValue: mutableSnap)
            }
            
            mutableSnap.value = 1
            return TransactionResult.success(withValue: mutableSnap)
        }
    }
    
    class func userFollowDELETE(userId: String) {
        guard let selfUserId = Auth.auth().currentUser?.uid else { return }
        followingRef.child(selfUserId).child(userId).removeValue()
        followerRef.child(userId).child(selfUserId).removeValue()
        
        followingCountRef.child(selfUserId).child("count").runTransactionBlock { (mutableSnap) -> TransactionResult in
            if let count = mutableSnap.value as? Int {
                mutableSnap.value = count - 1
                return TransactionResult.success(withValue: mutableSnap)
            }
            
            mutableSnap.value = 0
            return TransactionResult.success(withValue: mutableSnap)
        }
        
        followerCountRef.child(userId).child("count").runTransactionBlock { (mutableSnap) -> TransactionResult in
            if let count = mutableSnap.value as? Int {
                mutableSnap.value = count - 1
                return TransactionResult.success(withValue: mutableSnap)
            }
            
            mutableSnap.value = 0
            return TransactionResult.success(withValue: mutableSnap)
        }
        
    }
    
    class func userSelfIsFollowing(userId: String, completion: @escaping (Bool?) -> Void) {
        guard let selfUserId = Auth.auth().currentUser?.uid else { return }
        followingRef.child(selfUserId).child(userId).observeSingleEvent(of: .value) { (snap) in
            if let result = snap.value as? Bool {
                completion(result)
            } else {
                completion(nil)
            }
        }
    }
    
    class func userSelfIsFollowing(userId: String) -> Promise<Bool> {
        return Promise { fullfilled, reject in
            guard let selfUserId = Auth.auth().currentUser?.uid else { return reject(ApiError.userUnauthenticated) }
            followingRef.child(selfUserId).child(userId).observeSingleEvent(of: .value) { (snap) in
                if let result = snap.value as? Bool {
                    fullfilled(result)
                } else {
                    reject(ApiError.unknown)
                }
            }
        }
    }
    
    class func usersFollowersObserver(userId: String, completion: @escaping (UserDetail?) -> Void) {
        followerRef.child(userId).observe(.childAdded) { (snap) in
            let childUserId = snap.key
            usersUserIdGET(userId: childUserId, completion: completion)
        }
    }
    
    class func usersFollowingsObserver(userId: String, completion: @escaping (UserDetail?) -> Void) {
        followingRef.child(userId).observe(.childAdded) { (snap) in
            let childUserId = snap.key
            usersUserIdGET(userId: childUserId, completion: completion)
        }
    }
    
    class func userFollowersCountGET(userId: String, completion: @escaping (Int?) -> Void) {
        followerCountRef.child(userId).child("count").observeSingleEvent(of: .value) { (snap) in
            if let count = snap.value as? Int {
                completion(count)
            } else {
                completion(nil)
            }
        }
    }
    
    class func userFollowersCountGET(userId: String) -> Promise<Int> {
       return  Promise { fullfilled, reject in
            followerCountRef.child(userId).child("count").observeSingleEvent(of: .value) { (snap) in
                if let count = snap.value as? Int {
                    fullfilled(count)
                } else {
                    reject(ApiError.unknown)
                }
            }
        }
    }
    
    class func userFollowingsCountGET(userId: String, completion: @escaping (Int?) -> Void) {
        followingCountRef.child(userId).child("count").observeSingleEvent(of: .value) { (snap) in
            if let count = snap.value as? Int {
                completion(count)
            } else {
                completion(nil)
            }
        }
    }
    
    class func userFollowingsCountGET(userId: String) -> Promise<Int> {
        return Promise { fullfilled, reject  in
            followingCountRef.child(userId).child("count").observeSingleEvent(of: .value) { (snap) in
                if let count = snap.value as? Int {
                    fullfilled(count)
                } else {
                    reject(ApiError.unknown)
                }
            }
        }
    }
    
    class func userSelfFollowersCountGET(completion: @escaping (Int?) -> Void) {
        guard let selfId = Auth.auth().currentUser?.uid else { return }
        followerCountRef.child(selfId).child("count").observeSingleEvent(of: .value) { (snap) in
            if let count = snap.value as? Int {
                completion(count)
            } else {
                completion(nil)
            }
        }
    }
    
    class func userSelfFollowersCountGET() -> Promise<Int> {
       return  Promise { fullfilled, reject in
            guard let selfId = Auth.auth().currentUser?.uid else {
                return reject(ApiError.userUnauthenticated)
            }
        
            followerCountRef.child(selfId).child("count").observeSingleEvent(of: .value) { (snap) in
                if let count = snap.value as? Int {
                    fullfilled(count)
                } else {
                    reject(ApiError.unknown)
                }
            }
        }
    }
    
    class func userSelfFollowingsCountGET(completion: @escaping (Int?) -> Void) {
        guard let selfId = Auth.auth().currentUser?.uid else { return }
        followingCountRef.child(selfId).child("count").observeSingleEvent(of: .value) { (snap) in
            if let count = snap.value as? Int {
                completion(count)
            } else {
                completion(nil)
            }
        }
    }
    
    class func userSelfFollowingCountGET() -> Promise<Int> {
        return Promise { fullfilled, reject in
            guard let selfId = Auth.auth().currentUser?.uid else { return reject(ApiError.userUnauthenticated)}
            followingCountRef.child(selfId).child("count").observeSingleEvent(of: .value, with: { (snap) in
                if let count = snap.value as? Int {
                    fullfilled(count)
                } else {
                    reject(ApiError.unknown)
                }
            })
        }
    }
}




