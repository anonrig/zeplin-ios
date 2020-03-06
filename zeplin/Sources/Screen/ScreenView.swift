//
//  ScreenView.swift
//  zeplin
//
//  Created by yagiz on 3/4/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import SnapKit
import RxSwift
import UIKit

final class ScreenView: UIView {
    // MARK: - Properties
    var bag = DisposeBag()

    private(set) var screenModeButton: UIButton = .create(numberOfLines: 1, horizontalAlignment: .trailing, verticalAlignment: .center, backgroundColor: .clear, backgroundImage: nil, image: nil, title: "Fit".localized(), titleColor: Colors.mustardYellow.color, font: .regular(17))
    
    private(set) lazy var screenImage: UIImageView = {
        let view = UIImageView(image: nil)
        view.kf.indicatorType = .activity
        view.contentMode = .center
        return view
    }()

    private(set) lazy var imageScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.addSubview(screenImage)
        view.contentMode = .scaleAspectFit
        screenImage.snp.makeConstraints { $0.edges.equalTo(view) }
        return view
    }()

    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        [imageScrollView].forEach(addSubview(_:))
        
        imageScrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
