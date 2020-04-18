//
//  ProjectView.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa

final class ProjectView: UIView {
  // MARK: - Properties
  var bag = DisposeBag()
  
  private let emptyView = ProjectsEmptyView()
  
  let editModeButton: UIButton = {
    let view: UIButton = .create(numberOfLines: 1, horizontalAlignment: .trailing, verticalAlignment: .center, backgroundColor: .clear, title: "Select".localized(), titleColor: Colors.mustardYellow.color, font: .regular(17))
    
    view.snp.makeConstraints { $0.width.equalTo(70) }
    return view
  }()
  
  private let flowLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    let width = (UIScreen.main.bounds.width - 71) / 2
    layout.itemSize = CGSize(width: width, height: width)
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 23
    layout.minimumLineSpacing = 23
    layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    layout.invalidateLayout()
    return layout
  }()
  
  let refreshControl = UIRefreshControl()
  
  private(set) lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.backgroundColor = .clear
    collectionView.alwaysBounceVertical = true
    collectionView.register(cellType: ScreenCell.self)
    collectionView.register(supplementaryViewType: ScreenSectionHeaderView.self,
                            ofKind: UICollectionView.elementKindSectionHeader)
    collectionView.refreshControl = refreshControl
    return collectionView
  }()
  
  private let projectEditBar: ProjectEditBarView = ProjectEditBarView()
  
  // MARK: - Initialization
  init() {
    super.init(frame: .zero)
    
    [collectionView, projectEditBar].forEach(addSubview(_:))
    projectEditBar.isHidden = true
    collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    projectEditBar.snp.makeConstraints {
      $0.bottom.leading.trailing.equalToSuperview()
      $0.height.equalTo(UIApplication.mainWindow.safeAreaInsets.bottom + 50)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ProjectView {
  func setProjectEditBarHidden(_ hidden: Bool) {
    projectEditBar.isHidden = hidden
  }
  
  func setProjectEditBarState(title: String, enabled: Bool) {
    projectEditBar.setTitle(title)
    projectEditBar.setDeleteButtonHidden(enabled)
  }
  
  func onProjectDelete() -> ControlEvent<Void> {
    return projectEditBar.onDelete()
  }
}
