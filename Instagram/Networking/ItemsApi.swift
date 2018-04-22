//
//  ItemsApi.swift
//  Instagram
//
//  Created by Kaushal on 28/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase
import PromiseKit

class ItemsApi: BaseApi {
    static let quoteRef = Database.database().reference().child("Quote")
    static let userQuoteRef = Database.database().reference().child("UserQuote")
    
    class func itemPOST(_ body: PostItem, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(ApiError.userUnauthenticated)
            return
        }
        
        var boyd = body
        boyd.userId = userId
        guard let data = try? FirebaseEncoder().encode(boyd) else { return completion(ApiError.parsing) }
        
        
        // 1. create data at `Quote` table
        quoteRef.childByAutoId().setValue(data) { (error, dbRef) in
            if let err = error {
                return completion(err)
            }
            // 2. create data at `UserQuote` relational table
            createUserQuoteRelation(userId: userId, quoteId: dbRef.key, completion: completion)
        }
    }
    
    class func itemByQuoteId(quoteId: String, completion: @escaping (Quote?) -> Void) {
        quoteRef.child(quoteId).observeSingleEvent(of: .value) { handleResponse($0, completion: completion) }
    }
    
    class func itemByQuoteId(quoteId: String) ->  Promise<Quote> {
        return quoteRef.child(quoteId).observeSingleEvent().then(execute: handleResponse)
    }
    
    
    class func itemsAllQuotes(completion: @escaping ([Quote]?) -> Void) {
        quoteRef.observeSingleEvent(of: .value, with: {handleListResponse($0, completion: completion)})
    }
    
    class func itemsAllQuotes() -> Promise<[Quote]> {
        return quoteRef.observeSingleEvent().then(execute: handleListResponse)
    }
}

extension ItemsApi {
    fileprivate class func createUserQuoteRelation(userId: String, quoteId: String, completion: @escaping (Error?) -> Void) {
        
        userQuoteRef.child(userId).child(quoteId).setValue(true) { (error, dbRef) in
            completion(error)
        }
    }
}
