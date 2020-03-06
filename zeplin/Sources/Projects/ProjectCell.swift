//
//  ProjectCell.swift
//  zeplin
//
//  Created by yagiz on 2/29/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import SnapKit

final class ProjectCell: UICollectionViewCell {
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.kf.indicatorType = .activity
        view.contentMode = .scaleAspectFill
        view.backgroundColor = Colors.windowBackgroundBlack.color
        view.clipsToBounds = true
        return view
    }()
    
  private var platformLabel: UILabel = .create(text: "", numberOfLines: 1, textAlignment: .left, textColor: Colors.loginButtonBlue.color, font: .medium(12))
  private var dateLabel: UILabel = .create(text: "", numberOfLines: 1, textAlignment: .right, textColor: Colors.descriptionGray.color, font: .medium(12))
    
    private var projectLabel: UILabel = .create(text: "", numberOfLines: 1, textAlignment: .left, textColor: .white, font: .medium(12))
    
    private var memberCountLabel: UILabel = .create(text: "", numberOfLines: 1, textAlignment: .right, textColor: Colors.descriptionGray.color, font: .semiBold(11))

    private lazy var horizontalStack: UIStackView = .create(arrangedSubViews: [platformLabel, dateLabel], axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 0)
    
    private var memberStack: UIStackView = .create(arrangedSubViews: [UIView(), UIView(), UIView(), UIView(), UIView()], axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 4)
    private lazy var memberStackContainer: UIView = {
        let view = UIView()
        view.addSubview(memberStack)
        memberStack.snp.makeConstraints { $0.edges.equalTo(view) }
        return view
    }()
    private lazy var userStack: UIStackView = .create(arrangedSubViews: [memberStackContainer, memberCountLabel], axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 5)
    private lazy var verticalStack: UIStackView = .create(arrangedSubViews: [horizontalStack, projectLabel, userStack], axis: .vertical, alignment: .fill, distribution: .fill, spacing: 2)
    private lazy var bottomContainer: UIView = {
        let view = UIView()
        view.addSubview(verticalStack)
        verticalStack.snp.makeConstraints { $0.edges.equalTo(view).inset(UIEdgeInsets(top: 12, left: 12, bottom: 10, right: 12))}
        return view
    }()
    
    private lazy var mainStack: UIStackView = .create(arrangedSubViews: [imageView, bottomContainer], axis: .vertical, alignment: .fill, distribution: .fillEqually, spacing: 0)
    private lazy var overlay: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.profileButtonsBackground.color
        return view
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        [mainStack, overlay].forEach(addSubview(_:))
        backgroundColor = Colors.profileButtonsBackground.color
        cornerRadius = 4
        
        mainStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        verticalStack.setCustomSpacing(8, after: projectLabel)
        overlay.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Populate project
extension ProjectCell {
    func populate(with project: Project, isArchived: Bool = false) {
        overlay.alpha = isArchived ? 0.5 : 0

        memberStack.removeArrangedSubviews()

        if let thumbnail = project.thumbnail, let url = URL(string: thumbnail) {
            imageView.kf.setImage(with: url)
        }
        
        if let platform = project.platform {
            platformLabel.text = String(describing: platform).uppercased()
        }
        dateLabel.text = project.created?.dateString(ofStyle: .short)
        projectLabel.text = project.name
        if let members = project.number_of_members {
            memberCountLabel.text = members - 5 > 0 ? "+" + (members - 5).string : ""
        }
        
        for n in 0...4 {
            if let member = project.members.at(index: n), let user = member.user {
                if let avatar = user.avatar, let url = URL(string: avatar) {
                    let imageView = UIImageView()
                    imageView.kf.setImage(with: url)
                    imageView.kf.indicatorType = .activity
                    imageView.contentMode = .scaleAspectFill
                    imageView.snp.makeConstraints { $0.size.equalTo(16)}
                    imageView.cornerRadius = 8
                    memberStack.addArrangedSubview(imageView)
                } else if let emotar = user.emotar {
                    let label = UILabel()
                    label.text = emotar
                    label.snp.makeConstraints { $0.size.equalTo(16)}
                    label.sizeToFit()
                    label.font = .medium(11)
                    memberStack.addArrangedSubview(label)
                } else {
                    let label = UILabel()
                    label.text = (user.username ?? "").prefix(2).uppercased()
                    label.backgroundColor = .black
                    label.font = .semiBold(8)
                    label.textAlignment = .center
                    label.cornerRadius = 8
                    label.snp.makeConstraints { $0.size.equalTo(16)}
                    label.sizeToFit()
                    memberStack.addArrangedSubview(label)
                }
            } else {
                memberStack.addArrangedSubview(UIView())
            }
        }
    }
}
