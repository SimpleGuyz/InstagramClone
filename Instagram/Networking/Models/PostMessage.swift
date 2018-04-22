//
//  PostMessage.swift
//  Instagram
//
//  Created by Kaushal on 10/04/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation
import UIKit
import CodableFirebase

class PostMessage: Codable  {
    var content: String?
    var userId: String?
    var time: String?
}
