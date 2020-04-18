//
//  LoginSteps.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation
import RxFlow

enum LoginSteps: Step {
  case required
  case webLoginRequired
  case webLoginCompleted(response: CallbackResponse)
}

