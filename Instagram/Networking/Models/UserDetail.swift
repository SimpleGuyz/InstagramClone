//
//  UserDetail.swift
//  Instagram
//
//  Created by Kaushal on 05/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation

class UserDetail: Codable, Modelable {
    var id: String?
    var avatarURL: String?
    var bio: String?
    var fullname: String?
    var gender: String?
    var email: String?
}

class UserNew: NSObject {
    var id: String?
    var avatarURL: String?
    var bio: String?
    var fullname: String?
    var gender: String?
    var email: String?
}



