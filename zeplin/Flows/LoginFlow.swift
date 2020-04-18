//
//  LoginFlow.swift
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
import ToolkitRxSwift

class LoginFlow: Flow {
  var root: Presentable {
    return self.rootViewController
  }
  
  private let bag = DisposeBag()
  private let services: AppServices
  private let appStepper: AppStepper
  let loginFlowStepper: LoginFlowStepper = .init()
  
  private lazy var rootViewController: UINavigationController = {
    let viewController = UINavigationController()
    viewController.setNavigationBarHidden(true, animated: false)
    return viewController
  }()
  
  init(withServices services: AppServices, withAppStepper stepper: AppStepper) {
    self.services = services
    self.appStepper = stepper
  }
  
  deinit {
    print("\(type(of: self)): \(#function)")
  }
  
  func navigate(to step: Step) -> FlowContributors {
    if let step = step as? AppSteps {
      switch step {
      case .deeplinkReceived(let url):
        return handleDeepLink(url: url)
      default:
        return .none
      }
    }

    guard let step = step as? LoginSteps  else { return .none }
    switch step {
    case .required:
      return navigateToLogin()
    case .webLoginRequired:
      return navigateToWebLogin()
    case .webLoginCompleted(let response):
      return webLoginCompleted(response: response)
    }
  }
  
  func navigateToLogin() -> FlowContributors {
    let viewController = LoginViewController.instantiate(withViewModel: LoginViewModel(), andServices: services)
    rootViewController.pushViewController(viewController, animated: false)
    
    let steppers = CompositeStepper(steppers: [appStepper, viewController.viewModel, loginFlowStepper])
    return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: steppers))
  }
  
  func navigateToWebLogin() -> FlowContributors {
    let flow = WebLoginFlow(withServices: services)
    
    Flows.whenReady(flow1: flow) { (root: UINavigationController) in
      self.rootViewController.present(root, animated: true, completion: nil)
    }
    
    return .one(flowContributor: .contribute(withNextPresentable: flow,
                                             withNextStepper: OneStepper(withSingleStep: WebLoginSteps.required)))
  }
  
  func handleDeepLink(url: URL) -> FlowContributors {
    rootViewController.rx.showAction.onNext(.init(image: UIImage(named: "error")!,
                                                  title: "Login Required".localized(),
                                                  description: "Please login in order to access this project.".localized(),
                                                  actionTitle: "LOGIN".localized(), onAction: loginFlowStepper.onAction))
    return .none
  }
  
  func webLoginCompleted(response: CallbackResponse) -> FlowContributors {
    services.preferenceServices.login(with: response)
    return .end(forwardToParentFlowWithStep: AppSteps.projectsRequired)
  }
}

class LoginFlowStepper: Stepper {
  let steps = PublishRelay<Step>()
  let onAction = PublishSubject<Void>()
  let bag = DisposeBag()

  init() {
    onAction
      .asObservable()
      .map { _ in LoginSteps.webLoginRequired }
      .bind(to: steps)
      .disposed(by: bag)
  }
}
