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
import ios_toolkit
import WebKit

final class LoginWebViewController: UIViewController, View, ErrorDisplayer, LoadingHandler {
    // MARK: - Properties
    private lazy var viewSource = LoginWebView()
    
    private(set) var bag: DisposeBag
    private(set) var viewModel: LoginWebViewModel
    private(set) var completionObservable = PublishSubject<CallbackResponse?>()
    private(set) var loadingView: LoadingView
    
    // MARK: - Initialization
    init() {
        bag = DisposeBag()
        viewModel = LoginWebViewModel()
        loadingView = LoadingView()
        
        super.init(nibName: nil, bundle: nil)
        
        bindLoading()
        bindErrorHandling()
        observeDatasource()
    }
    
    // MARK: - Life cycle
    override func loadView() {
        view = viewSource
        view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewSource.webView.cleanAllCookies()
        viewSource.webView.refreshCookies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "logoZeplin"))
        
        // set fake user agent
        let userAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36"
        viewSource.webView.customUserAgent = userAgent
        
        let url = URL(string: "https://api.zeplin.dev/v1/oauth/authorize?response_type=code&client_id=5e55244862025d78ef97b512&redirect_uri=https://api.relevantfruit.com/v1/zeplin/callback&state=login")!
    
        let urlRequest = URLRequest(url: url)
        viewSource.webView.load(urlRequest)
    }

}

// MARK: - Observe Datasource
private extension LoginWebViewController {
    private func observeDatasource() {
        viewSource.webView.navigationDelegate = self
    }
}

// MARK: - WebView Delegate
extension LoginWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let path = webView.url?.absoluteString {
            if path.contains("/v1/zeplin") {
                webView
                    .evaluateJavaScript("document.documentElement.querySelector('pre').innerHTML.toString()", completionHandler: { (html: Any?, error: Error?) in
                        if let response = html as? String {
                            self.completionObservable.onNext(CallbackResponse(JSONString: response))
                        } else {
                            self.completionObservable.onNext(nil)
                        }
                        self.completionObservable.onCompleted()
                    
                })
            }
        }
    }
}
