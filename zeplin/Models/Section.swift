//
//  Section.swift
//  zeplin
//
//  Created by yagiz on 3/1/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import Mapper

struct Section: Mappable {
    let id: String
    let name: String
    let created: Date
    
    init(map: Mapper) throws {
        try id = map.from("id")
        try name = map.from("name")
        try created = map.from("created")
    }
}


