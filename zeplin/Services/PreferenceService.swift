//
//  PreferenceService.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ToolkitRxSwift
import Toolkit

protocol HasPreferenceService {
  var preferenceServices: PreferenceService { get }
}

class PreferenceService {
  let user = BehaviorRelay<User?>(value: nil)
  
  func isLoggedIn() -> Bool {
    return user.value != nil
  }
  
  func logout() {
    Keychain.delete([.token])
    user.accept(nil)
  }
  
  func login(with response: CallbackResponse) {
    Keychain.save(credentials: [.token(response.token)])
    user.accept(response.user)
  }
}
