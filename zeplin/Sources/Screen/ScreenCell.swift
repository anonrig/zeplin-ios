//
//  ScreenCell.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import SnapKit
import ios_toolkit

final class ScreenCell: UICollectionViewCell {
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.kf.indicatorType = .activity
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        return view
    }()
    
    private var screenNameLabel: PaddingLabel = {
        let view = PaddingLabel()
        view.numberOfLines = 1
        view.textAlignment = .left
        view.textColor = .white
        view.font = .medium(12)
        view.backgroundColor = UIColor(hex: 0x2f3033)
        view.padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        view.snp.makeConstraints { $0.height.equalTo(32) }
        return view
    }()
    
    private lazy var verticalStack: UIStackView = .create(arrangedSubViews: [imageView, screenNameLabel], axis: .vertical, alignment: .fill, distribution: .fill, spacing: 0)
    
    private var selectedImageView = UIImageView(image: UIImage(named: "icoSelected"))
    private lazy var overlay: UIView = {
        let view = UIView()
        view.addSubview(selectedImageView)
        selectedImageView.snp.makeConstraints { $0.top.trailing.equalTo(view).inset(UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 6))}
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return view
    }()
    
    private var editModeEnabled: Bool = false
    
    override var isSelected: Bool {
        didSet {
            self.overlay.isHidden = !isSelected && !editModeEnabled
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        [verticalStack, overlay].forEach(addSubview(_:))
        backgroundColor = UIColor(hex: 0x2f3033)
        cornerRadius = 4
        
        verticalStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        overlay.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Populate project
extension ScreenCell {
    func populate(with screen: Screen, editMode: Bool = false) {
        editModeEnabled = editMode

        if let image = screen.image?.original_url, let url = URL(string: image) {
            imageView.kf.setImage(with: url)
        }
        
        if let name = screen.name {
            screenNameLabel.text = name
        }
    }
}

