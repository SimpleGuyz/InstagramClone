//
//  ConversationsModel.swift
//  Instagram
//
//  Created by alice singh on 09/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation

class MessageItem {
    var toId: String? //receiver id
    var message: String?
    var time: Int?
    var fromId: String? //current user id Or SendersId
}

/* let timestamp: NSNumber = Int(NSDate().timeIntervalSince1970) */
