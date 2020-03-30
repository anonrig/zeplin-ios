//
//  LoginWebView.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import SnapKit
import UIKit
import Toolkit
import WebKit

final class LoginWebView: UIView {
    // MARK: - Properties
    private(set) var webViewConfig: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        config.applicationNameForUserAgent = "Version/8.0.2 Safari/600.2.5"
        return config
    }()
    
    private(set) lazy var webView: WKWebView = WKWebView(frame: .zero, configuration: webViewConfig)
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        [webView].forEach(addSubview(_:))
        
        webView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
