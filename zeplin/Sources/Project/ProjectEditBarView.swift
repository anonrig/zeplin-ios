//
//  ProjectEditBarView.swift
//  zeplin
//
//  Created by yagiz on 3/1/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import SnapKit
import UIKit

final class ProjectEditBarView: UIView {
    // MARK: - Properties
    private(set) var titleLabel: UILabel = .create(text: "Select Screens".localized(), numberOfLines: 0, textAlignment: .center, textColor: .white, font: .semiBold(17))
    
    private(set) var deleteButton: UIButton = .create(numberOfLines: 1, horizontalAlignment: .center, verticalAlignment: .center, backgroundColor: .clear, backgroundImage: nil, image: UIImage(named: "icoDelete"), title: "", titleColor: .clear, font: .bold(12))
        
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
      backgroundColor = Colors.profileButtonsBackground.color
        
        [titleLabel, deleteButton].forEach(addSubview(_:))
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.centerY.equalTo(deleteButton)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalTo(self).inset(UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 16))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

