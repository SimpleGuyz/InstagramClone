//
//  SearchApi.swift
//  Instagram
//
//  Created by Kaushal on 31/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation
import FirebaseDatabase
import PromiseKit

class SearchApi: BaseApi {
    static let userRef = Database.database().reference().child("User")
    static let userQuoteRef = Database.database().reference().child("Quote")
    /// requires to collect all results
    class func searchUserObserverBy(fullname: String, completion: @escaping (UserDetail?) -> Void) {
        userRef.queryOrdered(byChild: "fullname")
            .queryStarting(atValue: fullname).queryEnding(atValue:  fullname + "\u{f8ff}")   //
            .observe(.childAdded) { handleResponse($0, completion: completion) }
    }
    
    class func searchUserBy(fullname: String, completion: @escaping ([UserDetail]?) -> Void) {
        userRef.queryOrdered(byChild: "fullname")
            .queryStarting(atValue: fullname).queryEnding(atValue:  fullname + "\u{f8ff}")
            .queryLimited(toFirst: 10)
            .observeSingleEvent(of: .value) { handleListResponse($0, completion: completion) }
    }
    
    class func searchUserBy(fullname: String, count: UInt = 10) -> Promise<[UserDetail]> {
        return userRef.queryOrdered(byChild: "fullname")
                .queryStarting(atValue: fullname).queryEnding(atValue:  fullname + "\u{f8ff}")
                .queryLimited(toFirst: count)
                .observeSingleEvent().then(execute: handleListResponse)
    }
}

