//
//  User.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import ObjectMapper

struct User: Mappable {
    var identifier: String?
    var email: String?
    var username: String?
    var emotar: String?
    var avatar: String?
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        identifier <- map["identifier"]
        email <- map["email"]
        username <- map["username"]
        emotar <- map["emotar"]
        avatar <- map["avatar"]
    }
}
