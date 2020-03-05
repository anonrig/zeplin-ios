//
//  Extensions.swift
//  qrtfy
//
//  Created by yagiz on 1/26/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import RxSwift

var appVersion: String {
    guard let dictionary = Bundle.main.infoDictionary,
        let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
    return version
}

var appName: String {
    let name = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String
    return name ?? ""
}

var bundleID: String {
    return Bundle.main.bundleIdentifier ?? ""
}


extension UINavigationController {
    func setupStyling() {
        navigationBar.backgroundColor = UIColor(hex: 0x1d1d1d)
        navigationBar.isTranslucent = false
        navigationBar.setTitleFont(.semiBold(17))
        navigationBar.tintColor = UIColor(hex: 0xfecf33)
        
        if #available(iOS 13.0, *) {
            navigationBar.standardAppearance.backgroundColor = UIColor(hex: 0x1d1d1d)
            navigationBar.compactAppearance?.backgroundColor = UIColor(hex: 0x1d1d1d)
            navigationBar.scrollEdgeAppearance?.backgroundColor = UIColor(hex: 0x1d1d1d)
        } else {
            // Fallback on earlier versions
        }
    }
}

extension UIImageView {
    func withAlpha(_ alpha: CGFloat) -> UIImageView {
        self.alpha = alpha
        return self
    }
}

extension UIFont {
    static func semiBold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func bold(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static func regular(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func medium(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
}

extension WKWebView {

    func cleanAllCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

    func refreshCookies() {
        self.configuration.processPool = WKProcessPool()
    }
}

public protocol OptionalType {
  associatedtype Wrapped

  var optional: Wrapped? { get }
}

extension Optional: OptionalType {
  public var optional: Wrapped? { return self }
}

extension Observable where Element: OptionalType {
  func ignoreNil() -> Observable<Element.Wrapped> {
    return flatMap { value in
      value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
    }
  }
}
