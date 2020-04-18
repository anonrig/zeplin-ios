//
//  ZeplinService.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation
import UIKit
import ToolkitRxSwift
import Toolkit
import Moya
import RxMoya
import RxMoya_ModelMapper
import RxCocoa
import RxSwift

protocol HasZeplinService {
  var zeplinServices: ZeplinService { get }
}

class ZeplinService {
  private let provider = MoyaProvider<ZeplinProvider>()
  
  func getCurrentUser() -> Observable<User> {
    return provider.rx.request(.getCurrentUser)
      .map(to: User.self, keyPath: "user")
      .asObservable()
  }
  
  func getProjects() -> Observable<[Project]> {
    return provider.rx.request(.getProjects)
      .map(to: [Project].self, keyPath: "projects")
      .asObservable()
  }
  
  func getScreens(for project: Project) -> Observable<[ScreenSection]> {
    return provider.rx.request(.getScreens(project: project))
      .map(to: [ScreenSection].self, keyPath: "sections")
      .asObservable()
  }
  
  func deleteScreen(for screen: Screen, with project: Project) -> Observable<Void> {
    return provider.rx.request(.deleteScreen(screen: screen, project: project))
      .map { _ in }
      .asObservable()
  }
}
