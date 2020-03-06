//
//  NotificationsComingSoonView.swift
//  zeplin
//
//  Created by yagiz on 3/5/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import SnapKit
import UIKit
import ios_toolkit

final class NotificationsComingSoonView: UIView {
    // MARK: - Properties
    private var headerLabel: UILabel = .create(text: "Too soon!".localized(), numberOfLines: 0, textAlignment: .left, textColor: .white, font: .bold(22))
  private var descriptionLabel: UILabel = .create(text: "We are currently working on this feature right now. Your notifications will appear here when Zeplin API provides them.".localized(), numberOfLines: 0, textAlignment: .left, textColor: Colors.descriptionGray.color, font: .regular(11))
    
    private var imageView: UIImageView = UIImageView(image: UIImage(named: "imgApi"))
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        [headerLabel, descriptionLabel, imageView].forEach(addSubview(_:))
        
        headerLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(self).inset(UIEdgeInsets(top: 20, left: 24, bottom: 0, right: 24))
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(self).inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
            $0.top.equalTo(headerLabel.snp.bottom).offset(8)
        }
        
        imageView.snp.makeConstraints {
            $0.center.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

