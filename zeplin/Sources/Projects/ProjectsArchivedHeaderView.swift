//
//  ProjectsArchivedHeaderView.swift
//  zeplin
//
//  Created by yagiz on 3/3/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa

final class ProjectsArchivedHeaderView: UICollectionReusableView {
    // MARK: - Properties
    var bag: DisposeBag = DisposeBag()

    private var titleLabel: UILabel = .create(text: "Archived Projects".localized(), numberOfLines: 1, textAlignment: .left, textColor: .white, font: .bold(22))
    
    private var descriptionLabel: UILabel = {
        let texts = [
            "These projects are not accessible by invited users.",
            "Owners and admins can re-activate them anytime from the web, if they have a subscription."
        ].joined(separator: "\n")
        
        return .create(text: texts, numberOfLines: 0, textAlignment: .left, textColor: UIColor(hex: 0xa1a2a3)!, font: .regular(11))
    }()
    
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
        
        [titleLabel, collapseButton, descriptionLabel].forEach(addSubview(_:))
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0))
        }
        
        collapseButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
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

private extension ProjectsArchivedHeaderView {
    private func listenForTaps() {
        collapseButton.rx.tap
            .asObservable()
            .map { _ in !self.isCollapsed.value}
            .bind(to: isCollapsed)
            .disposed(by: bag)
        
        isCollapsed
            .asObservable()
            .map { $0 ? self.chevronUpImage : self.chevronDownImage}
            .bind(to: collapseButton.rx.image(for: .normal))
            .disposed(by: bag)
    }
}
