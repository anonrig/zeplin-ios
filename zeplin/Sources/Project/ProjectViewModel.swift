//
//  ProjectViewModel.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//


//
//  LoginWebViewModel.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow
import UIKit
import Toolkit

final class ProjectViewModel: ServicesViewModel, Stepper {
  typealias Services = AppServices
  
  // MARK: - Properties
  var services: Services!
  let steps = PublishRelay<Step>()
  let bag = DisposeBag()
  
  // MARK: - Properties
  let sections = BehaviorRelay<[ScreenSection]>(value: [])
  let project: Project
  let editModeEnabled = BehaviorRelay<Bool>(value: false)
  let selectedScreens = BehaviorRelay<[Screen]>(value: [])
  
  init(with project: Project) {
    self.project = project
  }
}

// MARK: - Fetch resource
extension ProjectViewModel {
  func getScreens() -> Observable<[ScreenSection]> {
    return services.zeplinServices.getScreens(for: project)
  }
  
  func screenRequired(screen: Screen) {
    steps.accept(ProjectsSteps.screenRequired(screen: screen))
  }
}
