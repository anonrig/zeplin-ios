//
//  ProjectsHeaderView.swift
//  zeplin
//
//  Created by yagiz on 3/3/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import SnapKit
import UIKit
import Reusable

final class ProjectsHeaderView: UICollectionReusableView, Reusable {
  // MARK: - Properties
  private let titleLabel: UILabel = .create(text: "Projects".localized(), numberOfLines: 1, textAlignment: .left, textColor: .white, font: .bold(34))
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    [titleLabel].forEach(addSubview(_:))
    
    titleLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
        .inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static var defaultHeight: CGFloat = 41
}
