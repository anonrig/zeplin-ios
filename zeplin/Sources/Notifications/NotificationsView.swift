//
//  NotificationsView.swift
//  zeplin
//
//  Created by yagiz on 3/2/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import SnapKit
import UIKit

final class NotificationsView: UIView {
    // MARK: - Properties
    private(set) var emptyView = NotificationsEmptyView()
    private(set) var comingSoonView = NotificationsComingSoonView()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        [comingSoonView].forEach(addSubview(_:))
        
        comingSoonView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
