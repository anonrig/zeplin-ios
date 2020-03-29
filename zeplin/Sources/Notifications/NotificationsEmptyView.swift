//
//  NotificationsEmptyView.swift
//  zeplin
//
//  Created by yagiz on 3/2/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import SnapKit
import UIKit
import Toolkit

final class NotificationsEmptyView: UIView {
    // MARK: - Properties
    private var headerLabel: UILabel = .create(text: "You have no notifications.".localized(), numberOfLines: 0, textAlignment: .left, textColor: .white, font: .bold(22))
    
    private var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "imgNotificationEmpty"))
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        [headerLabel, imageView].forEach(addSubview(_:))
        
        headerLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(self).inset(UIEdgeInsets(top: 20, left: 24, bottom: 0, right: 24))
        }
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
            $0.top.equalTo(headerLabel.snp.bottom).offset(24)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

