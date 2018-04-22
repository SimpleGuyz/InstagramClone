//
//  UserProfile.swift
//  Instagram
//
//  Created by alice singh on 07/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation

class UserProfile {
    var id: String?
    var avatarURL: String?
    var bio: String?
    var fullname: String?
    var gender: String?
    var email: String?
}

class Followers {
    var id: String?
    var followers: [UserProfile]?
}

class Following {
    var id: String?
    var following: [UserProfile]?
}
