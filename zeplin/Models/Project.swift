//
//  Project.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import ObjectMapper
import Foundation
import RxDataSources

struct Project: Mappable, IdentifiableType, Equatable {
    typealias Identity = Int

    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }
    
    var identity: Identity {
        return (id ?? "0").hashValue
    }
    
    var id: String?
    var name: String?
    var description: String?
    var platform: Platform?
    var thumbnail: String?
    var status: ProjectStatus?
    var scene_url: String?
    var created: Date?
    var updated: Date?
    var number_of_members: Int?
    var number_of_screens: Int?
    var number_of_components: Int?
    var number_of_text_styles: Int?
    var number_of_colors: Int?
    var members: [Member] = []
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        platform <- map["platform"]
        thumbnail <- map["thumbnail"]
        status <- map["status"]
        scene_url <- map["scene_url"]
        created <- (map["created"], DateTransform())
        updated <- (map["updated"], DateTransform())
        number_of_members <- map["number_of_members"]
        number_of_screens <- map["number_of_screens"]
        number_of_components <- map["number_of_components"]
        number_of_text_styles <- map["number_of_text_styles"]
        number_of_colors <- map["number_of_colors"]
        members <- map["members"]
    }
}
