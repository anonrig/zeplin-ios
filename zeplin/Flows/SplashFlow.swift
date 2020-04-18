//
//  SplashFlow.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxSwift
import RxFlow
import UIKit

class SplashFlow: Flow {
  var root: Presentable {
    self.rootViewController
  }
  
  let rootViewController: UINavigationController = {
    let viewController = UINavigationController()
    viewController.setNavigationBarHidden(true, animated: false)
    return viewController
  }()

  let appServices: AppServices
  
  init(withServices appServices: AppServices) {
    self.appServices = appServices
  }
  
  deinit {
    print("\(type(of: self)): \(#function)")
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? AppSteps else { return .none }
    
    switch step {
    case .splashRequired:
      return navigateToSplash()
    default:
      return .none
    }
  }
  
  func navigateToSplash() -> FlowContributors {
    let viewController = SplashViewController.instantiate(withViewModel: SplashViewModel(), andServices: appServices)
    rootViewController.pushViewController(viewController, animated: false)
    return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                             withNextStepper: viewController.viewModel,
                                             allowStepWhenNotPresented: false))
  }
}
