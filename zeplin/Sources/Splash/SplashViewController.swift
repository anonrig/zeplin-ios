//
//  SplashViewController.swift
//  zeplin
//
//  Created by yagiz on 4/17/20.
//  Copyright © 2020 Yagiz Nizipli. All rights reserved.
//

import UIKit
import RxSwift
import Toolkit
import ToolkitRxSwift

final class SplashViewController: UIViewController, ViewModelBased {
  
  // MARK: - Properties
  var viewModel: SplashViewModel!
  let viewSource = SplashView()
  let bag = DisposeBag()

  // MARK: - Life cycle
  override func loadView() {
    view = viewSource
    view.backgroundColor = Colors.windowBackgroundBlack.color
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.checkLogin()
  }
}
