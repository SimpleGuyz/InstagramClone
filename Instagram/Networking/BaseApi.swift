//
//  DataProvider.swift
//  Instagram
//
//  Created by Kaushal on 18/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import CodableFirebase
import PromiseKit


protocol Modelable: Codable {
    var id: String? { get set }
}

protocol BaseApi {
    static func handleListResponse<T: Modelable>(_ snap: DataSnapshot, completion: ([T]?) -> Void)
    static func handleResponse<T: Modelable>(_ snap: DataSnapshot, completion: (T?) -> Void)
    static func createModel<U: Modelable>(_ child: Any) -> U?
}

extension BaseApi { // default implementations
    static func handleListResponse<T: Modelable>(_ snap: DataSnapshot, completion: ([T]?) -> Void) {
        let models: [T]? = snap.children.allObjects.flatMap(createModel)
        completion(models)
    }
    
    static func createModel<U: Modelable>(_ child: Any) -> U? {
        let childSnap = child as? DataSnapshot
        let key = childSnap?.key
        
        var model: U? = try? FirebaseDecoder().decode(U.self, from: (childSnap?.value)!)
        model?.id = key
        return model
    }
    
    static func handleResponse<T: Modelable>(_ snap: DataSnapshot, completion: (T?) -> Void) {
        let model: T? = createModel(snap)
        completion(model)
    }
    
    static func handleListResponse<T: Modelable>(_ snap: DataSnapshot) -> Promise<[T]> {
        if let models: [T] = snap.children.allObjects.flatMap(createModel) {
            return Promise(value: models)
        }
        
        return Promise(error: ApiError.parsing)
    }
    
    static func handleResponse<T: Modelable>(_ snap: DataSnapshot) -> Promise<T> {
        if let model: T = createModel(snap) {
            return Promise(value: model)
        }
        
        return Promise(error: ApiError.parsing)
    }
}

extension DatabaseReference {
    func setValue(value: Any?) -> Promise<DatabaseReference> {
        
        return Promise { fulfill, reject in
            setValue(value, withCompletionBlock: { (error, dbRef) in
                if let error = error {
                    reject(error)
                    return
                }
                fulfill(dbRef)
            })
        }
    }
    
    func setValueIgnoreResult(_ value: Any?) -> Promise<Void> {
        return Promise { fulfill, reject in
            setValue(value, withCompletionBlock: { (error, dbRef) in
                if let error = error {
                    reject(error)
                    return
                }
                fulfill(())
            })
        }
    }
}

extension DatabaseQuery {
    func observeSingleEvent() -> Promise<DataSnapshot> {
        return Promise { fulfill, reject in
            observeSingleEvent(of: .value, with: fulfill, withCancel: reject)
        }
    }
    
}




extension BaseApi {
    /*
    class func handleFeedResponse(_ snap: DataSnapshot, completion: CompletionFeed) {
        let models: [FeedItem] = snap.children.allObjects.map(createModel)
        completion(models)
    }
    
    class func createModel(_ child: Any) -> FeedItem {
        // 1. extract value dictionary
        let childSnap = child as? DataSnapshot
        let key = childSnap?.key
        
        // 2. decode to model
        let model = try? FirebaseDecoder().decode(FeedItem.self, from: (childSnap?.value)!)
        model?.id = key
        return model!
    }
 */
}
