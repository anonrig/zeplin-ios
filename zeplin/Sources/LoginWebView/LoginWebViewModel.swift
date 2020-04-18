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

final class LoginWebViewModel: ServicesViewModel, Stepper {
  typealias Services = AppServices
  
  // MARK: - Properties
  var services: Services!
  let steps = PublishRelay<Step>()
  let bag = DisposeBag()
  
  func dismissRequired() {
    steps.accept(WebLoginSteps.dismissed)
  }
  
  func completed(with response: CallbackResponse) {
    steps.accept(WebLoginSteps.completed(response: response))
  }
}
