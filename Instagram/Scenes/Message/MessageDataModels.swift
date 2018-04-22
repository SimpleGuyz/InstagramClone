//
//  MessageDataModels.swift
//  Instagram
//
//  Created by Kaushal on 05/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation

struct Message: Codable, Modelable {
    var id: String?
    var content: String?
    var userId: String?
    var time: String? // epoch time
}

struct Conversation {
    var id: String?
    var participants: [String]? // array of userIds
    var messages: [Message]?
}

struct ConversationShort {
    var id: String?
    var oppoDetail: UserDetail?
    var lastMessage: Message?
}

// view models

struct ConversationShortViewModel {
    var id: String?
    var oppoDetail: UserDetail?
    var lastMessage: String?
}

struct MessageViewModel {
    var id: String
    var content: String
    var usersName: String
    var time: String // 12:20 pm
    var isSelf: Bool
}
