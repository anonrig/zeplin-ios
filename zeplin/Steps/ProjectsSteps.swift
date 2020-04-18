//
//  ProjectsSteps.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation
import RxFlow

enum ProjectsSteps: Step {
  case required
  case notificationsRequired
  case profileRequired
  case logoutRequired
  case projectRequired(project: Project)
  case screenRequired(screen: Screen)
}
