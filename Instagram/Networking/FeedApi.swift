//
//  FeedApi.swift
//  Instagram
//
//  Created by Kaushal on 24/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation
import FirebaseDatabase
import PromiseKit
import FirebaseAuth

class FeedApi: BaseApi {
    static let quoteRef = Database.database().reference().child("Quote")
    
    class func feedGET(_ compeletion: @escaping ([FeedItem]?) -> Void) {
        quoteRef.observeSingleEvent(of: .value) { handleListResponse($0, completion: compeletion) }
    }
    
    class func feedGET() -> Promise<[FeedItem]> {
        //let selfId = Auth.auth().currentUser?.uid
        return quoteRef.queryOrderedByKey()
            .queryLimited(toFirst: 20)
            .observeSingleEvent()
            .then(execute: handleListResponse) // quotes
            .then(execute: mapQuotesToFeed)
            .then(execute: reverseOrder)
    }
    
    class func mapQuotesToFeed(_ items: [Quote]) -> Promise<[FeedItem]> {
        return when(fulfilled: items.map(convertToFeedItem))
    }
    
    class func convertToFeedItem(_ quote: Quote) -> Promise<FeedItem> {
        return UsersApi
            .usersUserIdGET(userId: quote.userId ?? "fakeId")
            .then { merge(quote: quote, user: $0) }
    }
    
    class func merge(quote: Quote, user: UserDetail) -> Promise<FeedItem> {
        let feedItem = FeedItem()
        feedItem.id = quote.id
        feedItem.quote = quote.quote
        feedItem.place = quote.place
        feedItem.userId = quote.userId
        
        feedItem.userFullname = user.fullname
        feedItem.userImageUrl = user.avatarURL
        return Promise(value: feedItem)
    }
    
    class func reverseOrder(_ feed: [FeedItem]) -> Promise<[FeedItem]>{
        let result = Array(feed.reversed())
        return Promise(value: result)
    }
}




