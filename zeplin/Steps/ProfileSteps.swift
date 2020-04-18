//
//  ProfileSteps.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation
import RxFlow

enum ProfileSteps: Step {
  case required
  case externalPageRequire(url: URL)
  case contactRequired
  case rateRequired
  case logoutRequired
}
