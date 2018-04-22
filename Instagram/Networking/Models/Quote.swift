//
//  Quote.swift
//  Instagram
//
//  Created by Kaushal on 17/03/18.
//  Copyright © 2018 alice singh. All rights reserved.
//

import Foundation

class Quote: Codable, Modelable {
    var id: String?
    var quote: String?
    var place: String?
    var userId: String?
}
