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

final class ProjectView: UIView {
    // MARK: - Properties
    var bag = DisposeBag()
    
    private var emptyView = ProjectsEmptyView()
    
    private(set) var editModeButton: UIButton = .create(numberOfLines: 1, horizontalAlignment: .trailing, verticalAlignment: .center, backgroundColor: .clear, title: "Select".localized(), titleColor: UIColor(hex: 0xfecf33)!, font: .regular(17))
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 71) / 2
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 23
        layout.minimumLineSpacing = 23
        layout.sectionInset = .zero
        layout.invalidateLayout()
        return layout
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24)
        collectionView.register(ScreenCell.self, forCellWithReuseIdentifier: "ScreenCell")
        collectionView.register(supplementaryViewOfKind: "ScreenSectionHeaderView", withClass: ScreenSectionHeaderView.self)
        return collectionView
    }()
    
    private(set) var projectEditBar: ProjectEditBarView = ProjectEditBarView()

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
