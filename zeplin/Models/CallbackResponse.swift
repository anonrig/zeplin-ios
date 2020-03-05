//
//  CallbackResponse.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import ObjectMapper

struct CallbackResponse: Mappable {
    var user: User?
    var token: String?
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        user <- map["user"]
        token <- map["token"]
    }
}
