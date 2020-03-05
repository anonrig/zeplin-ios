//
//  Section.swift
//  zeplin
//
//  Created by yagiz on 3/1/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import ObjectMapper

struct Section: Mappable {
    var id: String?
    var name: String?
    var created: Date?
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        created <- (map["created"], DateTransform())
    }
}


