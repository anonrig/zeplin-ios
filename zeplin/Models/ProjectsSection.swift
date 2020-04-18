//
//  ProjectsSection.swift
//  zeplin
//
//  Created by yagiz on 3/3/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources
import UIKit

struct ProjectsSection {
  let header: String
  let status: ProjectStatus
  var projects: [Project]
  var isCollapsed: Bool = false
}

extension ProjectsSection: AnimatableSectionModelType {
  typealias Item = Project
  typealias Identity = Int
  
  var identity: Int {
    return header.hashValue
  }
  
  var items: [Item] {
    return isCollapsed ? [] : projects.map { $0 }
  }
  
  init(original: ProjectsSection, items: [Item]) {
    self = original
    self.projects = items
  }
}

extension Sequence where Iterator.Element == ProjectsSection {
  func get(for status: ProjectStatus) -> [ProjectsSection] {
    return self.filter { $0.status == status }
  }
}
