//
//  Screen.swift
//  zeplin
//
//  Created by yagiz on 3/1/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import Toolkit
import RxDataSources
import Mapper

struct Screen: Mappable, IdentifiableType, Equatable {
  typealias Identity = Int
  
  static func == (lhs: Screen, rhs: Screen) -> Bool {
    return lhs.id == rhs.id
  }
  
  var identity: Identity {
    return id.hashValue
  }
  
  let id: String
  let name: String?
  let description: String?
  let tags: [String]
  let image: Image?
  let created: Date
  let updated: Date
  let number_of_notes: Int?
  let number_of_versions: Int?
  let section: Section?
  
  init(map: Mapper) throws {
    try id = map.from("id")
    name = map.optionalFrom("name")
    description = map.optionalFrom("description")
    tags = map.optionalFrom("tags") ?? []
    image = map.optionalFrom("image")
    try created = map.from("created")
    try updated = map.from("updated")
    number_of_notes = map.optionalFrom("number_of_notes")
    number_of_versions = map.optionalFrom("number_of_versions")
    section = map.optionalFrom("section")
  }
}

