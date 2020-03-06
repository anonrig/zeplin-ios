//
//  ProjectsEmptyView.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import SnapKit
import UIKit

final class ProjectsEmptyView: UIView {
    // MARK: - Properties
    private var titleLabel: UILabel = .create(text: "You have no projects".localized(), numberOfLines: 0, textAlignment: .left, textColor: .white, font: .bold(22))
    
  private var descriptionLabel: UILabel = .create(text: "When you create a project on Zeplin, it will appear here.".localized(), numberOfLines: 0, textAlignment: .left, textColor: Colors.profileButtonsBackground.color, font: .regular(11))
    
    private var projectEmptyImage = UIImage(named: "projectEmpty")
    
    private lazy var verticalStack: UIStackView = .create(arrangedSubViews: [
        titleLabel,
        descriptionLabel,
        UIStackView.create(arrangedSubViews: [
            UIImageView(image: projectEmptyImage),
            UIImageView(image: projectEmptyImage)
        ], axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 23),
        UIStackView.create(arrangedSubViews: [
            UIImageView(image: projectEmptyImage).withAlpha(0.75),
            UIImageView(image: projectEmptyImage).withAlpha(0.75)
        ], axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 23),
        UIStackView.create(arrangedSubViews: [
            UIImageView(image: projectEmptyImage).withAlpha(0.5),
            UIView()
        ], axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 23)
    ], axis: .vertical, alignment: .fill, distribution: .fill, spacing: 23)
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        [verticalStack].forEach(addSubview(_:))
        
        verticalStack.snp.makeConstraints { $0.leading.trailing.top.equalTo(self).inset(UIEdgeInsets(top: 20, left: 24, bottom: 24, right: 24))}
        
        verticalStack.setCustomSpacing(8, after: titleLabel)
        verticalStack.setCustomSpacing(24, after: descriptionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
