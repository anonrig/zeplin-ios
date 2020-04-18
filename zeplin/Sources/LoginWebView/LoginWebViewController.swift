//
//  LoginWebViewController.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit
import Toolkit
import WebKit
import Mapper

final class LoginWebViewController: UIViewController, ViewModelBased {
  
  // MARK: - Properties
  var viewModel: LoginWebViewModel!
  let viewSource = LoginWebView()
  let bag = DisposeBag()
  
  // MARK: - Life cycle
  override func loadView() {
    view = viewSource
    view.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: viewSource.closeButton)
    navigationItem.titleView = UIImageView(image: UIImage(named: "logoZeplin"))
    
    // Setting fake user agent is important to enable logging in with Google.
    viewSource.webView.customUserAgent = AppConfig.userAgent.value
    
    if let url = URL(string: AppConfig.callbackUrl.value) {
      viewSource.webView.load(URLRequest(url: url))
    }
    
    observeDatasource()
  }
}

// MARK: - Observe Datasource
private extension LoginWebViewController {
  private func observeDatasource() {
    viewSource.webView.navigationDelegate = self
    
    viewSource.onClose()
      .asDriver()
      .drive(onNext: { _ in self.viewModel.dismissRequired() })
      .disposed(by: viewSource.bag)
  }
}

// MARK: - WebView Delegate
extension LoginWebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if let path = webView.url?.absoluteString {
      if path.contains("/v1/zeplin") {
        
        webView
          .evaluateJavaScript(AppConfig.documentQueryPath.value, completionHandler: { (html: Any?, error: Error?) in
            if let error = error {
              return self.rx.showAlert.onNext(.init(message: "An error occurred while getting response. \(error.localizedDescription)".localized()))
            }
            
            if let response = html as? String,
              let data = response.data(using: .utf8),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
              let callbackResponse = try? CallbackResponse(map: Mapper(JSON: dictionary)) {
              
              self.viewModel.completed(with: callbackResponse)
            } else {
              self.rx.showAlert.onNext(.init(message: "An error occurred. Response from Zeplin servers are wrong."))
            }
          })
      }
    }
  }
}
