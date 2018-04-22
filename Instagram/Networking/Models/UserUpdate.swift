//
//  UserUpdate.swift
//  Instagram
//
//  Created by Kaushal on 05/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation

class UserUpdate: Codable {
    var avatarURL: String?
    var bio: String?
    var fullname: String?
    var gender: String?
    var email: String?
}

class QuoteUpdate: Codable {
    var place: String?
    var quote: String?
}
