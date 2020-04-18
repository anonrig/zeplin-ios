//
//  CallbackResponse.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import Mapper

struct CallbackResponse: Mappable {
  let user: User
  let token: String
  
  init(map: Mapper) throws {
    try user = map.from("user")
    try token = map.from("token")
  }
}
