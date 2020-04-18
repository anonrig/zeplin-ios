//
//  Image.swift
//  zeplin
//
//  Created by yagiz on 3/1/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import Mapper

struct Image: Mappable {
  let width: Int
  let height: Int
  let original_url: String?
  
  init(map: Mapper) throws {
    try width = map.from("width")
    try height = map.from("height")
    original_url = map.optionalFrom("original_url")
  }
}

