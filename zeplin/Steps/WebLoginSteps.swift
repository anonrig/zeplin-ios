//
//  WebLoginSteps.swift
//  zeplin
//
//  Created by yagiz on 4/18/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation
import RxFlow

enum WebLoginSteps: Step {
  case required
  case dismissed
  case completed(response: CallbackResponse)
}
