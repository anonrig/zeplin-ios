//
//  Screen.swift
//  zeplin
//
//  Created by yagiz on 3/1/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import ObjectMapper
import RxDataSources

struct Screen: Mappable, IdentifiableType, Equatable {
    typealias Identity = Int

    static func == (lhs: Screen, rhs: Screen) -> Bool {
        return lhs.id == rhs.id
    }
    
    var identity: Identity {
        return (id ?? "0").hashValue
    }
    
    var id: String?
    var name: String?
    var description: String?
    var tags: [String] = []
    var image: Image?
    var created: Date?
    var updated: Date?
    var number_of_notes: Int?
    var number_of_versions: Int?
    var section: Section?
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        tags <- map["tags"]
        image <- map["image"]
        created <- (map["created"], DateTransform())
        updated <- (map["updated"], DateTransform())
        number_of_notes <- map["number_of_notes"]
        number_of_versions <- map["number_of_versions"]
        section <- map["section"]
    }
}

