//
//  Image.swift
//  zeplin
//
//  Created by yagiz on 3/1/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import ObjectMapper

struct Image: Mappable {
    var width: Int = 0
    var height: Int = 0
    var original_url: String?
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        width <- map["width"]
        height <- map["height"]
        original_url <- map["original_url"]
    }
}

