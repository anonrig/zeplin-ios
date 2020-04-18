//
//  ScreenViewModel.swift
//  zeplin
//
//  Created by yagiz on 3/4/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxSwift
import RxCocoa
import Toolkit
import RxFlow
import Kingfisher
import UIKit

final class ScreenViewModel: ServicesViewModel, Stepper {
  typealias Services = AppServices
  
  // MARK: - Properties
  var services: Services!
  let steps = PublishRelay<Step>()
  let bag = DisposeBag()
  let screen: Screen
  let isOriginalMode = BehaviorRelay<Bool>(value: true)
  let statusBarHidden = BehaviorRelay<Bool>(value: false)

  init(with currentScreen: Screen) {
    screen = currentScreen
  }
}

// MARK: - Helpers
extension ScreenViewModel {
  func toggleStatusBar() {
    statusBarHidden.accept(!statusBarHidden.value)
  }
  
  func getImage() -> Observable<UIImage?> {
    guard let url = URL(string: screen.image?.original_url ?? "") else { return .just(nil) }
    return Observable.create { observer in
      KingfisherManager.shared.retrieveImage(with: url) { result in
        switch result {
        case .success(let king):
          observer.onNext(king.image)
        case .failure(let error):
          observer.onError(error)
        }
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
}
