//
//  StorageApi.swift
//  Instagram
//
//  Created by alice singh on 05/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation
import FirebaseStorage
import UIKit
import PromiseKit

class UploadApi: BaseApi {
    static let baseRef = Storage.storage().reference().child("Images")
    
    class func uploadImage(_ url: URL, completion: @escaping (URL?) -> Void) {
        let uniqueId = UUID().uuidString
        baseRef.child(uniqueId).putFile(from: url, metadata: nil) { (meta, error) in
            if let error = error {
                print(error)
                completion(nil)
                return
            }
            completion(meta?.downloadURL())
        }
    }
    
    class func uploadImage(_ url: URL, progress: @escaping (Double) -> Void) -> Promise<URL> {
        let uniqueId = UUID().uuidString
        
        return Promise { pass, fail in
            let task = baseRef.child(uniqueId).putFile(from: url, metadata: nil)
            
            // 1. progress
            task.observe(.progress) { (snap) in
                progress(snap.progress?.fractionCompleted ?? 0)
            }
            
            // 2. Success
            task.observe(.success) { (snap) in
                if let url = snap.metadata?.downloadURL() {
                    pass(url)
                } else {
                    fail(ApiError.parsing)
                }
            }
            
            // 3. failure
            task.observe(.failure) { (snap) in
                fail(snap.error ?? ApiError.unknown)
            }
        }
    }
}






