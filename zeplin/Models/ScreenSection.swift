//
//  ScreenSection.swift
//  zeplin
//
//  Created by yagiz on 3/4/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import Mapper
import RxDataSources

struct ScreenSection: Mappable {
    let id: String
    let name: String
    let identity: String
    var screens: [Item]
    var isCollapsed: Bool
    
    init(map: Mapper) throws {
        try id = map.from("id")
        try name = map.from("name")
        try identity = map.from("identity")
        screens = map.optionalFrom("screens") ?? []
        isCollapsed = map.optionalFrom("isCollapsed") ?? false
    }
}

extension ScreenSection: AnimatableSectionModelType {
    typealias Item = Screen
    typealias Identity = String
    
    var items: [Screen] {
        return isCollapsed ? [] : screens.map { $0 }
    }

    init(original: ScreenSection, items: [Item]) {
        self = original
        self.screens = items
    }
}

