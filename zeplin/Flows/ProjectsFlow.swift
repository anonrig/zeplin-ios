//
//  ProjectsFlow.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import UIKit
import StoreKit
import Toolkit

class ProjectsFlow: Flow {
  var root: Presentable {
    return self.rootViewController
  }
  
  private let services: AppServices
  
  private lazy var rootViewController: UINavigationController = {
    let vc = UINavigationController()
    vc.setupStyling()
    return vc
  }()
  
  init(withServices services: AppServices) {
    self.services = services
  }
  
  deinit {
    print("\(type(of: self)): \(#function)")
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? ProjectsSteps else { return .none }
    switch step {
    case .required:
      return navigateToProjects()
    case .notificationsRequired:
      return navigateToNotifications()
    case .profileRequired:
      return navigateToProfile()
    case .logoutRequired:
      return .end(forwardToParentFlowWithStep: AppSteps.logoutRequired)
    case .projectRequired(let project):
      return navigateToProject(project: project)
    case .screenRequired(let screen):
      return navigateToScreen(screen: screen)
    }
  }
  
  func navigateToProjects() -> FlowContributors {
    let viewController = ProjectsViewController.instantiate(withViewModel: ProjectsViewModel(), andServices: services)
    rootViewController.pushViewController(viewController, animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                             withNextStepper: viewController.viewModel))
  }
  
  func navigateToNotifications() -> FlowContributors {
    let viewController = NotificationsViewController.instantiate(withViewModel: NotificationsViewModel(), andServices: services)
    rootViewController.pushViewController(viewController, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                             withNextStepper: viewController.viewModel))
  }
  
  func navigateToProfile() -> FlowContributors {
    let flow = ProfileFlow(withServices: services)
    
    Flows.whenReady(flow1: flow) { (root: UIViewController) in
      self.rootViewController.pushViewController(root, animated: true)
    }
    
    return .one(flowContributor: .contribute(withNextPresentable: flow,
                                             withNextStepper: OneStepper(withSingleStep: ProfileSteps.required)))
  }
  
  func navigateToProject(project: Project) -> FlowContributors {
    let viewController = ProjectViewController.instantiate(withViewModel: ProjectViewModel(with: project), andServices: services)
    rootViewController.pushViewController(viewController, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                             withNextStepper: viewController.viewModel))
  }
  
  func navigateToScreen(screen: Screen) -> FlowContributors {
    let viewController = ScreenViewController.instantiate(withViewModel: ScreenViewModel(with: screen), andServices: services)
    rootViewController.pushViewController(viewController, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                             withNextStepper: viewController.viewModel, allowStepWhenNotPresented: false))
  }
}
