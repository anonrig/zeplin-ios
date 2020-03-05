//
//  ScreenSection.swift
//  zeplin
//
//  Created by yagiz on 3/4/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import UIKit
import ObjectMapper

struct ScreenSection: Mappable {
    var id: String?
    var name: String?
    var identity: String = ""
    var screens: [Item] = []
    var isCollapsed: Bool = false
    
    init?(map: Map) {}
    
    init() {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        identity = id ?? ""
        screens <- map["screens"]
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

