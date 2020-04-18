//
//  SplashViewModel.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxSwift
import RxCocoa
import RxFlow
import UIKit
import Toolkit

final class SplashViewModel: ServicesViewModel, Stepper {
  typealias Services = AppServices
  
  // MARK: - Properties
  var services: Services!
  let steps = PublishRelay<Step>()
  let bag = DisposeBag()
  
  func checkLogin() {
    guard Keychain.has(.token) else { return self.services.onLoad.onNext(()) }
    
    services.zeplinServices.getCurrentUser()
      .do(onNext: {
        self.services.preferenceServices.user.accept($0)
        self.services.onLoad.onNext(())
        self.steps.accept(AppSteps.projectsRequired)
      }, onError: { _ in self.services.onLoad.onNext(()) })
      .asObservable()
      .subscribe()
      .disposed(by: bag)
  }
}
