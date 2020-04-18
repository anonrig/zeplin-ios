//
//  ProjectEditBarView.swift
//  zeplin
//
//  Created by yagiz on 3/1/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa

final class ProjectEditBarView: UIView {
  // MARK: - Properties
  private let titleLabel: UILabel = .create(text: "Select Screens".localized(), numberOfLines: 0, textAlignment: .center, textColor: .white, font: .semiBold(17))
  
  private let deleteButton: UIButton = .create(numberOfLines: 1, horizontalAlignment: .center, verticalAlignment: .center, backgroundColor: .clear, backgroundImage: nil, image: UIImage(named: "icoDelete"), title: "", titleColor: .clear, font: .bold(12))
  
  
  // MARK: - Initialization
  init() {
    super.init(frame: .zero)
    
    backgroundColor = Colors.profileButtonsBackground.color
    
    [titleLabel, deleteButton].forEach(addSubview(_:))
    
    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalTo(deleteButton)
    }
    
    deleteButton.snp.makeConstraints {
      $0.top.trailing.equalToSuperview()
        .inset(UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 16))
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ProjectEditBarView {
  func setTitle(_ title: String) {
    titleLabel.text = title
  }
  
  func setDeleteButtonHidden(_ isHidden: Bool) {
    deleteButton.isHidden = isHidden
  }
  
  func onDelete() -> ControlEvent<Void> {
    return deleteButton.rx.tap
  }
}
