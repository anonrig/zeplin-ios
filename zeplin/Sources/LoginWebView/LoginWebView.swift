//
//  LoginWebView.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import SnapKit
import UIKit
import ios_toolkit
import WebKit

final class LoginWebView: UIView {
    // MARK: - Properties
    private(set) var webView: WKWebView = WKWebView()
    
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
