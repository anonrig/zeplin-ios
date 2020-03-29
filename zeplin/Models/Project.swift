//
//  Project.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import Mapper
import Foundation
import RxDataSources

struct Project: Mappable, IdentifiableType, Equatable {
    typealias Identity = Int

    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }
    
    var identity: Identity {
        return id.hashValue
    }
    
    let id: String
    let name: String?
    let description: String?
    let platform: Platform?
    let thumbnail: String?
    let status: ProjectStatus?
    let scene_url: String?
    let created: Date?
    let updated: Date?
    let number_of_members: Int?
    let number_of_screens: Int?
    let number_of_components: Int?
    let number_of_text_styles: Int?
    let number_of_colors: Int?
    let members: [Member]
    
    init(map: Mapper) throws {
        try id = map.from("id")
        name = map.optionalFrom("name")
        description = map.optionalFrom("description")
        platform = map.optionalFrom("platform")
        thumbnail = map.optionalFrom("thumbnail")
        status = map.optionalFrom("status")
        scene_url = map.optionalFrom("scene_url")
        created = map.optionalFrom("created")
        updated = map.optionalFrom("updated")
        number_of_members = map.optionalFrom("number_of_members")
        number_of_screens = map.optionalFrom("number_of_screens")
        number_of_components = map.optionalFrom("number_of_components")
        number_of_text_styles = map.optionalFrom("number_of_text_styles")
        number_of_colors = map.optionalFrom("number_of_colors")
        members = map.optionalFrom("members") ?? []
    }
}

extension Sequence where Iterator.Element == Project {
    func get(for status: ProjectStatus) -> [Project] {
        return self.filter { $0.status == status }
    }
}
