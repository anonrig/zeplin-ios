//
//  WebLoginFlow.swift
//  zeplin
//
//  Created by yagiz on 4/18/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import UIKit
import StoreKit
import Toolkit

class WebLoginFlow: Flow {
  var root: Presentable {
    return self.rootViewController
  }
  
  private let services: AppServices
  
  private lazy var rootViewController: UINavigationController = {
    let viewController = UINavigationController()
    viewController.setupStyling()
    return viewController
  }()
  
  init(withServices services: AppServices) {
    self.services = services
  }
  
  deinit {
    print("\(type(of: self)): \(#function)")
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? WebLoginSteps  else { return .none }
    switch step {
    case .required:
      return navigateToLogin()
    case .dismissed:
      return dismissWebLogin()
    case .completed(let response):
      return webLoginCompleted(response: response)
    }
  }
  
  func navigateToLogin() -> FlowContributors {
    let viewController = LoginWebViewController.instantiate(withViewModel: LoginWebViewModel(), andServices: services)
    rootViewController.pushViewController(viewController, animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                             withNextStepper: viewController.viewModel))
  }
  
  func dismissWebLogin() -> FlowContributors {
    if let presentingController = rootViewController.presentingViewController {
      presentingController.dismiss(animated: true, completion: nil)
    }
    return .none
  }
  
  func webLoginCompleted(response: CallbackResponse) -> FlowContributors {
    if let presentingController = rootViewController.presentingViewController {
      presentingController.dismiss(animated: true, completion: nil)
    }
    
    return .end(forwardToParentFlowWithStep: LoginSteps.webLoginCompleted(response: response))
  }
}
