//
//  Member.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import ObjectMapper

struct Member: Mappable {
    var user: User?
    var role: String?
    var restricted: Bool = false
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        user <- map["user"]
        role <- map["role"]
        restricted <- map["restricted"]
    }
}

