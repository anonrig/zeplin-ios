//
//  LoadingView.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Lottie
import ToolkitRxSwift

final class LoadingView: UIView, LoadableView {
  private let animationView: AnimationView = {
    let view = AnimationView(name: "loading-animation")
    view.contentMode = .scaleAspectFill
    view.loopMode = .loop
    return view
  }()
  private lazy var container: UIView = .container(animationView)
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    [container].forEach(addSubview(_:))
    
    container.snp.makeConstraints { $0.center.equalToSuperview() }
    backgroundColor = Colors.windowBackgroundBlack.color.withAlphaComponent(0.75)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public attributes
extension LoadingView {
  func startAnimation() {
    animationView.play()
  }
}
