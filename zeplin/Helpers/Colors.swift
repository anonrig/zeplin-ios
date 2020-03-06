//
//  Colors.swift
//  zeplin
//
//  Created by onur.cantay on 06/03/2020.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit

enum Colors {
  case windowBackgroundBlack
  case mustardYellow
  case loginButtonBlue
  case descriptionGray
  case profileButtonsBackground
  case seperatorGray
  
  var color: UIColor {
    switch self {
    case .windowBackgroundBlack:
      return UIColor(named: "windowBackgroundBlack")!
    case .mustardYellow:
      return UIColor(named: "mustardYellow")!
    case .loginButtonBlue:
      return UIColor(named: "loginButtonBlue")!
    case .descriptionGray:
      return UIColor(named: "descriptionGray")!
    case .profileButtonsBackground:
      return UIColor(named: "profileButtonsBackground")!
    case .seperatorGray:
      return UIColor(named: "seperatorGray")!
    }
  }
}
