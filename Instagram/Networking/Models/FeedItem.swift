//
//  FeedItem.swift
//  Instagram
//
//  Created by Kaushal on 28/02/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation

class FeedItem: Codable, Modelable {
    var id: String?
    var quote: String?
    var place: String?
    var userId: String?
    
    var userFullname: String?
    var userImageUrl: String?
}
