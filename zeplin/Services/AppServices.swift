//
//  AppServices.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Toolkit
import Moya
import RxMoya
import RxMoya_ModelMapper
import ToolkitRxSwift
import RxFlow

protocol HasAppServices {
  var appServices: AppServices { get }
}

class AppServices: HasPreferenceService, HasZeplinService {
  var bag: DisposeBag
  
  let preferenceServices = PreferenceService()
  let zeplinServices = ZeplinService()
  let onLoad = PublishSubject<Void>()
  let deepLinkUrl = BehaviorRelay<URL?>(value: nil)
  
  init() {
    bag = DisposeBag()
  }
  
  func handleDeepLink(for url: URL) {
    deepLinkUrl.accept(url)
  }
}
