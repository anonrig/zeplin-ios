//
//  ScreenSectionHeaderView.swift
//  zeplin
//
//  Created by yagiz on 3/4/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import SnapKit
import RxSwift
import RxCocoa
import UIKit

final class ScreenSectionHeaderView: UICollectionReusableView {
    // MARK: - Properties
    var bag = DisposeBag()
    private var titleLabel: UILabel = .create(text: "".localized(), numberOfLines: 1, textAlignment: .left, textColor: .white, font: .bold(22))
    
    private var chevronDownImage = UIImage(named: "icoChevronDown")
    private var chevronUpImage = UIImage(named: "icoChevronUp")
    
    private(set) lazy var collapseButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(chevronDownImage, for: .normal)
        view.snp.makeConstraints { $0.size.equalTo(24) }
        return view
    }()
    
    private(set) var isCollapsed = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, collapseButton].forEach(addSubview(_:))
        
        titleLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 24, bottom: 20, right: 0))
            $0.trailing.equalTo(collapseButton.snp.leading).offset(-16)
        }
        
        collapseButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        listenForTaps()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        bag = DisposeBag()
        super.prepareForReuse()
        listenForTaps()
    }
}

extension ScreenSectionHeaderView {
    func populate(with title: String) {
        titleLabel.text = title
    }
}

private extension ScreenSectionHeaderView {
    private func listenForTaps() {
        collapseButton.rx.tap
            .asObservable()
            .map { _ in !self.isCollapsed.value}
            .bind(to: isCollapsed)
            .disposed(by: bag)
        
        isCollapsed
            .asObservable()
            .map { $0 ? self.chevronDownImage : self.chevronUpImage }
            .bind(to: collapseButton.rx.image(for: .normal))
            .disposed(by: bag)
    }
}
