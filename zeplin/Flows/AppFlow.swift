//
//  AppFlow.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import RxFlow
import RxCocoa
import RxSwift

class AppFlow: Flow {
  var root: Presentable {
    return self.rootViewController
  }
  
  private lazy var rootViewController: UIViewController = {
    let viewController = UINavigationController()
    viewController.setNavigationBarHidden(true, animated: false)
    return viewController
  }()
  
  private lazy var stepper = AppStepper(withServices: services)
  private let services: AppServices
  private let window: UIWindow
  
  init(window: UIWindow, services: AppServices) {
    self.window = window
    self.services = services
  }
  
  deinit {
    print("\(type(of: self)): \(#function)")
  }
  
  func adapt(step: Step) -> Single<Step> {
    guard let appStep = step as? AppSteps else { return .just(step) }
    
    switch appStep {
    case .projectsRequired:
      return services.preferenceServices.isLoggedIn() ?
        .just(AppSteps.projectsRequired) : .just(AppSteps.loginRequired)
    default:
      return .just(appStep)
    }
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? AppSteps else { return .none }

    switch step {
    case .splashRequired:
      return navigateToSplash()
    case .projectsRequired:
      return navigateToProjects()
    case .loginRequired:
      return navigateToLogin()
    case .logoutRequired:
      return prepareForLogout()
    default:
      return .none
    }
  }
  
  private func navigateToSplash() -> FlowContributors {
    let splashFlow = SplashFlow(withServices: self.services)
    
    Flows.whenReady(flow1: splashFlow) { [unowned self] root in
      self.window.rootViewController = root
      self.window.makeKeyAndVisible()
    }
    
    return .one(flowContributor: .contribute(withNextPresentable: splashFlow,
                                             withNextStepper: CompositeStepper(steppers: [OneStepper(withSingleStep: AppSteps.splashRequired), stepper])))
  }
  
  private func navigateToProjects() -> FlowContributors {
    let flow = ProjectsFlow(withServices: services)
    
    Flows.whenReady(flow1: flow) { (root: UINavigationController) in
      self.window.rootViewController = root
      self.window.makeKeyAndVisible()
    }
    
    return .one(flowContributor: .contribute(withNextPresentable: flow,
                                             withNextStepper: OneStepper(withSingleStep: ProjectsSteps.required),
                                             allowStepWhenNotPresented: true))
  }
  
  private func navigateToLogin() -> FlowContributors {
    let flow = LoginFlow(withServices: self.services, withAppStepper: stepper)
    
    Flows.whenReady(flow1: flow) { [unowned self] root in
      self.window.rootViewController = root
      self.window.makeKeyAndVisible()
    }
    
    return .multiple(flowContributors: [
      .contribute(withNextPresentable: flow, withNextStepper: stepper, allowStepWhenNotPresented: true),
      .contribute(withNextPresentable: flow, withNextStepper: OneStepper(withSingleStep: LoginSteps.required))
    ])
  }
  
  private func prepareForLogout() -> FlowContributors {
    services.preferenceServices.logout()
    return navigateToLogin()
  }
}

class AppStepper: Stepper {
  let steps = PublishRelay<Step>()
  private let appServices: AppServices
  private let bag = DisposeBag()
  
  init(withServices services: AppServices) {
    self.appServices = services
  }
  
  deinit {
    print("\(type(of: self)): \(#function)")
  }
  
  var initialStep: Step {
    return AppSteps.splashRequired
  }
  
  func readyToEmitSteps() {
    appServices
      .onLoad
      .map { _ in AppSteps.projectsRequired }
      .bind(to: steps)
      .disposed(by: bag)
    
    appServices
      .deepLinkUrl
      .distinctUntilChanged()
      .filter { $0 != nil }
      .map { $0! }
      .map { AppSteps.deeplinkReceived(url: $0) }
      .bind(to: steps)
      .disposed(by: bag)
  }
}
