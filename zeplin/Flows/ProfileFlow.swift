//
//  ProfileFlow.swift
//  zeplin
//
//  Created by yagiz on 4/18/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxFlow
import RxSwift
import RxCocoa
import UIKit
import SafariServices
import MessageUI
import StoreKit
import Toolkit

class ProfileFlow: Flow {
  var root: Presentable {
    return self.rootViewController
  }
  
  private let stepper = ProfileStepper()
  private let services: AppServices
  private lazy var rootViewController = ProfileViewController
    .instantiate(withViewModel: ProfileViewModel(), andServices: services)
  
  init(withServices services: AppServices) {
    self.services = services
  }
  
  deinit {
    print("\(type(of: self)): \(#function)")
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? ProfileSteps  else { return .none }
    switch step {
    case .required:
      return navigateToFlow()
    case .contactRequired:
      return navigateToContact()
    case .externalPageRequire(let url):
      return navigateToExternalPage(url)
    case .rateRequired:
      return navigateToRate()
    case .logoutRequired:
      return .end(forwardToParentFlowWithStep: ProjectsSteps.logoutRequired)
    }
  }
  
  func navigateToFlow() -> FlowContributors {
    return .one(flowContributor: .contribute(withNextPresentable: rootViewController,
                                             withNextStepper: rootViewController.viewModel))
  }
  
  private func navigateToExternalPage(_ url: URL) -> FlowContributors {
    let viewController = SFSafariViewController(url: url)
    
    rootViewController.present(viewController, animated: true)
    
    return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                             withNextStepper: CompositeStepper(steppers: []),
                                             allowStepWhenNotPresented: false))
  }
  
  private func navigateToContact() -> FlowContributors {
    guard MFMailComposeViewController.canSendMail() else { return .none }
    
    let viewController = MFMailComposeViewController()
    viewController.setToRecipients([AppConfig.contactEmail.value])
    viewController.setSubject(AppConfig.contactEmailTitle.value)
    viewController.mailComposeDelegate = stepper
    rootViewController.present(viewController, animated: true, completion: nil)
    
    return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                             withNextStepper: CompositeStepper(steppers: []),
                                             allowStepWhenNotPresented: false))
  }
  
  private func navigateToRate() -> FlowContributors {
    if #available(iOS 10.3, *) {
      SKStoreReviewController.requestReview()
    }
    return .none
  }
}

class ProfileStepper: NSObject, Stepper, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
  let steps = PublishRelay<Step>()
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}
