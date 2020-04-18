//
//  ProfileViewModel.swift
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

final class ProfileViewModel: ServicesViewModel, Stepper {
  typealias Services = AppServices
  
  // MARK: - Properties
  var services: Services!
  let steps = PublishRelay<Step>()
  let bag = DisposeBag()
  let user = BehaviorRelay<User?>(value: nil)
  
  func getCurrentUser() {
    services.preferenceServices.user
      .asObservable()
      .bind(to: user)
      .disposed(by: bag)
    
  }
  func actionRequired(_ action: ProfileSteps) {
    steps.accept(action)
  }
  
  func askForRating() {
    steps.accept(ProfileSteps.rateRequired)
  }
}
