//
//  ZeplinProvider.swift
//  zeplin
//
//  Created by yagiz on 3/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation
import Moya
import KeychainSwift
import Toolkit

enum ZeplinProvider {
  case getCurrentUser
  case getProjects
  case getScreens(project: Project)
  case deleteScreen(screen: Screen, project: Project)
}

extension ZeplinProvider: TargetType {
  var baseURL: URL { URL(string: "https://api.relevantfruit.com/v1/zeplin")! }
  
  var path: String {
    switch self {
    case .getCurrentUser:
      return "/user/me"
    case .getProjects:
      return "/projects"
    case .getScreens(let project):
      return "/projects/\(project.id)/screens"
    case .deleteScreen(let screen, let project):
      return "/projects/\(project.id)/screens/\(screen.id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getCurrentUser, .getProjects, .getScreens:
      return .get
    case .deleteScreen:
      return .delete
    }
  }
  
  var task: Task {
    switch self {
    case .getCurrentUser, .getProjects, .getScreens, .deleteScreen:
      return .requestPlain
    }
  }
  
  var headers: [String: String]? {
    var fields = ["Content-type": "application/json"]
    
    if let jwt = Keychain.get(.token) {
      fields["Authorization"] = jwt.value
    }
    
    return fields
  }
  
  var validationType: ValidationType { return .successCodes }
  
  var sampleData: Data { return Data() }
}
