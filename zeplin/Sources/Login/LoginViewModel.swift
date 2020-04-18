//
//  LoginViewModel.swift
//  zeplin
//
//  Created by yagiz on 3/2/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow
import UIKit
import Toolkit

final class LoginViewModel: ServicesViewModel, Stepper {
  typealias Services = AppServices
  
  // MARK: - Properties
  var services: Services!
  let steps = PublishRelay<Step>()
  let bag = DisposeBag()
  
  func webLoginRequired() {
    steps.accept(LoginSteps.webLoginRequired)
  }
}
