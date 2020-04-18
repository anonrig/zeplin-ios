//
//  AppSteps.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation
import RxFlow

enum AppSteps: Step {
  case splashRequired
  case loginRequired
  case projectsRequired
  case logoutRequired
  case deeplinkReceived(url: URL)
}
