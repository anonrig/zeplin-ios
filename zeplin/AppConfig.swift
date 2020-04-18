//
//  AppConfig.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation

enum AppConfig {
  case privacyPolicy
  case contactEmail
  case contactEmailTitle
  case appleId
  case oneSignalId
  case userAgent
  case callbackUrl
  case documentQueryPath
  case sentryDsn
  
  var value: String {
    switch self {
    case .privacyPolicy:
      return "https://api.relevantfruit.com/zeplin/privacy-policy"
    case .contactEmail:
      return "hello@relevantfruit.com"
    case .contactEmailTitle:
      return "Feedback: Zeplin iOS Client"
    case .appleId:
      return "1501596135"
    case .oneSignalId:
      return "3b3075a1-b7b0-4f9a-a72c-2856fa865ca4"
    case .userAgent:
      return "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1"
    case .callbackUrl:
      return "https://api.zeplin.dev/v1/oauth/authorize?response_type=code&client_id=5e55244862025d78ef97b512&redirect_uri=https://api.relevantfruit.com/v1/zeplin/callback&state=login"
    case .documentQueryPath:
      return "document.documentElement.querySelector('pre').innerHTML.toString()"
    case .sentryDsn:
      return "https://12983c50f7044b3885c6692190fa7789@o379034.ingest.sentry.io/5205037"
    }
  }
}
