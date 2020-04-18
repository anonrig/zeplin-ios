//
//  Member.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation
import Mapper

struct Member: Mappable {
  let user: User
  let role: String
  let restricted: Bool?
  
  init(map: Mapper) throws {
    try user = map.from("user")
    try role = map.from("role")
    restricted = map.optionalFrom("restricted") ?? false
  }
}

